//
//  ContentView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

class CustomAccessoryViewController: NSTitlebarAccessoryViewController {
    override func loadView() {
        // 在此处创建和配置自定义视图
        let customView = NSView(frame: NSRect(x: 0, y: 0, width: 100, height: 20))
        customView.wantsLayer = true
        customView.layer?.backgroundColor = NSColor.red.cgColor

        // 将自定义视图设置为 view
        self.view = customView
    }
}

struct ContentView: View {
    
    @State var isDropTargeted = false
    @State var isParseFinished = false
    
    @State var imageScale = 1.0
    
    @State var isDockIconHidden = false
    
    @State var project: WEProject!
    @State var projectUrl: URL!
    @State var greet: String = "Hello, world!"
    
    var body: some View {
        HSplitView {
            VStack(spacing: 5) {
                VStack(spacing: 0) {
                    HStack {
                        Group {
                            Button { } label: {
                                Label("Installed", systemImage: "square.and.arrow.down.fill")
                                    .padding(2)
                            }
                            .overlay(Rectangle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color.accentColor))
                            Button { } label: {
                                Label("Discover", systemImage: "doc.viewfinder.fill")
                                    .padding(2)
                            }
                            .overlay(Rectangle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color.accentColor))
                            Button { } label: {
                                Label("Workshop", systemImage: "globe")
                                    .padding(2)
                            }
                            .overlay(Rectangle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color.accentColor))
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Group {
                            Button { } label: {
                                Label("Mobile", systemImage: "platter.filled.bottom.iphone")
                            }
                            Button { } label: {
                                Label("Displays", systemImage: "display")
                            }
                            Button{
                                AppDelegate.shared.openSettingsWindow()
                            } label: {
                                Label("Settings", systemImage: "gearshape.fill")
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    Divider()
                        .frame(height: 2)
                        .overlay(Color.accentColor)
                }
                HStack {
                    TextField("Search", text: .constant(""))
                        .overlay {
                            HStack {
                                Spacer()
                                Button { } label: {
                                    Image(systemName: "magnifyingglass")
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(width: 160)
                    Button { } label: {
                        Label("Filter Results", systemImage: "checklist.checked")
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    Button { } label: {
                        Image(systemName: "arrowtriangle.up.fill")
                    }
                    .buttonStyle(.plain)
                    Menu("Name") {
                        Text("Name")
                        Text("Rating")
                        Text("Favorite")
                        Text("File Size")
                        Text("Subscription Date")
                        Text("Last Updated")
                    }
                    .frame(width: 160)
                }
                ScrollView {
                    Grid {
                        ForEach(0..<30) { _ in
                            GridRow {
                                ForEach(0..<5) { _ in
                                    ZStack {
                                        Image("sumeru")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaleEffect(imageScale)
                                            .clipShape(Rectangle())
                                            .animation(.default, value: imageScale)
                                        VStack {
                                            Spacer()
                                            ZStack {
                                                Rectangle()
                                                    .frame(height: 30)
                                                    .foregroundStyle(Color(white: 0, opacity: 0.25))
                                                Text("Sumeru【Genshin Impact】")
                                                    .font(.footnote)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundStyle(Color(white: 0.75))
                                                    .padding(.horizontal)
                                            }
                                        }
                                    }
                                    .onHover {
                                        if $0 {
                                            imageScale = 1.2
                                        } else {
                                            imageScale = 1.0
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.trailing)
                }
                .onDrop(of: [.folder], isTargeted: $isDropTargeted) { providers in
                    isParseFinished = false
                    // 确认拖入文件数量只有一个
                    if providers.count != 1 { return false }
                    let folder = providers.first!
                    // 确认拖入文件为`文件夹`类型
                    if !folder.hasItemConformingToTypeIdentifier("public.folder") { return false }
                    // 解析文件夹目录位置
                    folder.loadItem(forTypeIdentifier: "public.folder") { item, error in
                        let projectUrl = (item as! URL)
                        self.projectUrl = projectUrl
                        do {
                            // 根据解析出的目录下的project.json文件得到壁纸信息
                            let projectData = try Data(contentsOf: projectUrl.appendingPathComponent("project.json"))
                            project = try JSONDecoder().decode(WEProject.self, from: projectData)
                            isParseFinished = true
                        } catch {
                            return
                        }
                    }
                    return true
                }
                VStack {
                    HStack {
                        Text("Playlist").font(.largeTitle)
                        HStack(spacing: 2) {
                            Button { } label: {
                                Label("Load", systemImage: "folder.fill")
                            }
                            Button { } label: {
                                Label("Save", systemImage: "square.and.arrow.down.fill")
                            }
                            Button { } label: {
                                Label("Configure", systemImage: "gearshape.2.fill")
                            }
                            Button { } label: {
                                Label("Add Wallpaper", systemImage: "plus")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        Spacer()
                    }
                    HStack {
                        Button { } label: {
                            Label("Wallpaper Editor", systemImage: "pencil.and.ruler.fill")
                                .frame(width: 220)
                        }
                        .buttonStyle(.borderedProminent)
                        Button { } label: {
                            Label("Open Wallpaper", systemImage: "arrow.up.bin.fill")
                                .frame(width: 220)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack {
                            Image("sumeru")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Text("Sumeru 【Genshin Impact】")
                                .lineLimit(1)
                        }
                        HStack {
                            Image("we.logo")
                                .resizable()
                                .frame(width: 32, height: 32)
                            Text("< Pending >")
                        }
                        HStack {
                             HStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                            }
                            .font(.caption)
                            Button { } label: {
                                Image(systemName: "heart")
                            }
                        }
                        HStack {
                            Text("Video")
                            Text("40 MB")
                        }
                        .font(.footnote)
                        HStack(spacing: 3) {
                            Text("Fantasy")
                                .padding(5)
                                .background(Color(nsColor: NSColor.controlColor))
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            Text("3840 x 2160")
                                .padding(5)
                                .background(Color(nsColor: NSColor.controlColor))
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            Text("Everyone")
                                .padding(5)
                                .background(Color(nsColor: NSColor.controlColor))
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        }
                        .font(.footnote)
                        .lineLimit(1)
                        VStack(spacing: 3) {
                            Button { } label: {
                                Label("Unsubscribe", systemImage: "xmark")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            HStack(spacing: 3) {
                                Button { } label: {
                                    Label("Comment", systemImage: "text.badge.star")
                                        .frame(maxWidth: .infinity)
                                }
                                Button { } label: {
                                    Image(systemName: "doc.on.doc.fill")
                                }
                                Button { } label: {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                }
                            }
                        }
                        HStack(spacing: 3) {
                            Text("Properties")
                            VStack {
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color.accentColor)
                            }
                        }
                        VStack(spacing: 3) {
                            HStack(spacing: 3) {
                                Text("Your Presets")
                                VStack {
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color.accentColor)
                                }
                            }
                            HStack(spacing: 3) {
                                Button { } label: {
                                    Label("Load", systemImage: "folder.fill")
                                        .frame(maxWidth: .infinity)
                                    
                                }
                                Button { } label: {
                                    Label("Save", systemImage: "square.and.arrow.down.fill")
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            Button { } label: {
                                Label("Apply to all Wallpapers", systemImage: "list.bullet.rectangle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            Button { } label: {
                                Label("Share JSON", systemImage: "arrow.2.squarepath")
                                    .frame(maxWidth: .infinity)
                            }
                            Button { } label: {
                                Label("Reset", systemImage: "arrow.triangle.2.circlepath")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                HStack {
                    Spacer()
                    Button {
                        AppDelegate.shared.mainWindow.close()
                    } label: {
                        Text("OK").frame(width: 50)
                    }
                        .buttonStyle(.borderedProminent)
                    Button { } label: {
                        Text("Cancel").frame(width: 50)
                    }
                }
                .padding()
            }
            .frame(minWidth: 250, maxWidth: 500)
        }
        .frame(minWidth: 800, minHeight: 600)
//        Toggle(isOn: $isDockIconHidden) {
//            Label("Hide the dock icon", systemImage: "power")
//        }
//        .toggleStyle(.checkbox)
//        .onChange(of: isDockIconHidden) { newValue in
//            NSApplication.shared.setActivationPolicy(newValue ? .accessory : .regular)
//        }
//        VStack(spacing: 100) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 16.0)
//                    .stroke(lineWidth: 1)
//                    .foregroundColor(.secondary)
//                    .frame(minWidth: 80, maxWidth: 320, minHeight: 60, maxHeight: 240)
//                RoundedRectangle(cornerRadius: 16.0)
//                    .opacity(isDropTargeted ? 0.5 : 0)
//                    .animation(.default, value: isDropTargeted)
//                    .frame(minWidth: 80, maxWidth: 320, minHeight: 60, maxHeight: 240)
//                if isParseFinished {
//                    VStack {
//                        Text(project.title)
//                    }
//                } else {
//                    if isDropTargeted {
//                        Text("Release to parse to folder").font(.largeTitle)
//                    } else {
//                        Text("Drop your folder here ...").font(.largeTitle)
//                    }
//                }
//            }
//            .onDrop(of: [.folder], isTargeted: $isDropTargeted) { providers in
//                isParseFinished = false
//                // 确认拖入文件数量只有一个
//                if providers.count != 1 { return false }
//                let folder = providers.first!
//                // 确认拖入文件为`文件夹`类型
//                if !folder.hasItemConformingToTypeIdentifier("public.folder") { return false }
//                // 解析文件夹目录位置
//                folder.loadItem(forTypeIdentifier: "public.folder") { item, error in
//                    let projectUrl = (item as! URL)
//                    self.projectUrl = projectUrl
//                    do {
//                        // 根据解析出的目录下的project.json文件得到壁纸信息
//                        let projectData = try Data(contentsOf: projectUrl.appendingPathComponent("project.json"))
//                        project = try JSONDecoder().decode(WEProject.self, from: projectData)
//                        isParseFinished = true
//                    } catch {
//                        return
//                    }
//                }
//                return true
//            }
//            Button("Start") {
//                
//            }
//            .disabled(!isParseFinished)
//            TextField("Greet Message", text: $greet)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
