//
//  ContentView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isFilterReveal = true
    
    func toggleFilter() {
        isFilterReveal.toggle()
    }
}

struct FilterSection<Content>: View where Content: View {
    private let content: Content
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let titleKey: LocalizedStringKey
    
    @State private var isExpanded: Bool = true
    
    init(_ titleKey: LocalizedStringKey, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.alignment = alignment
        self.spacing = spacing
        self.titleKey = titleKey
    }
    
    var body: some View {
        VStack(alignment: self.alignment, spacing: self.spacing) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "arrowtriangle.down.fill")
                        .rotationEffect(isExpanded ? .zero : .degrees(-90.0))
                        .animation(.spring, value: isExpanded)
                    Text(self.titleKey)
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            if isExpanded {
                content
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @State var isDropTargeted = false
    @State var isParseFinished = false
    @State var isFilterReveal = true
    @State var isDisplaySettingsReveal = false
    
    @State var imageScales = [Double](repeating: 1.0, count: 6)
    @State var selectedIndex: Int!
    
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
                            Button {
                                isDisplaySettingsReveal = true
                            } label: {
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
                    Button {
                        viewModel.isFilterReveal.toggle()
                    } label: {
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
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        VStack {
                            // MARK: Filter Results
                            ScrollView {
                                VStack {
                                    Button {
                                         
                                    } label: {
                                        Label("Reset Filters", systemImage: "arrow.triangle.2.circlepath")
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 5)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    VStack(alignment: .leading) {
                                        Group {
                                            Toggle(isOn: .constant(true)) {
                                                HStack(spacing: 2) {
                                                    Image(systemName: "trophy.fill")
                                                        .foregroundStyle(Color.green)
                                                    Text("Approved")
                                                }
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                HStack(spacing: 2) {
                                                    Image(systemName: "heart.fill")
                                                        .foregroundStyle(Color.pink)
                                                    Text("My Favourites")
                                                }
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                HStack(spacing: 2) {
                                                    Image(systemName: "iphone.gen3")
                                                        .foregroundStyle(Color.orange)
                                                    Text("Mobile Compatible")
                                                }
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Audio Responsive")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Customizable")
                                            }
                                        }
                                    }
                                    .padding(.all)
                                    .padding(.top)
                                    .overlay {
                                        ZStack {
                                            Rectangle()
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(Color(nsColor: NSColor.unemphasizedSelectedTextBackgroundColor))
                                                .padding(.top, 8)
                                            VStack {
                                                HStack {
                                                    Text("Show Only:")
                                                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                                                        .padding(.leading, 5)
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                        }
                                        
                                    }
                                    Section("Hello") {
                                        VStack(alignment: .leading) {
                                            Toggle(isOn: .constant(true)) {
                                                Text("Scene")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Video")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Web")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Application")
                                            }
                                            Divider()
                                                .overlay(Color.accentColor)
                                            Toggle(isOn: .constant(true)) {
                                                Text("Wallpaper")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Preset")
                                            }
                                        }
                                    }
                                    Section("Age Rating") {
                                        VStack(alignment: .leading) {
                                            Toggle(isOn: .constant(true)) {
                                                Text("Scene")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Video")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Web")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Application")
                                            }
                                            Divider()
                                                .overlay(Color.accentColor)
                                            Toggle(isOn: .constant(true)) {
                                                Text("Wallpaper")
                                            }
                                            Toggle(isOn: .constant(true)) {
                                                Text("Preset")
                                            }
                                        }
                                    }
                                }
                                .padding(.trailing)
                            }
                        }
                        Divider()
                    }
                    .frame(width: viewModel.isFilterReveal ? 200 : 0)
                    .opacity(viewModel.isFilterReveal ? 1 : 0)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))]) {
                            ForEach(0..<2, id: \.self) { index in
                                ZStack {
                                    Image("sumeru")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(imageScales[index])
                                        .clipShape(Rectangle())
                                        .border(Color.accentColor, width: 5 * (imageScales[index] - 1))
                                        .selected(index == selectedIndex ?? 0)
                                        .animation(.default, value: imageScales)
                                    VStack {
                                        Spacer()
                                        ZStack {
                                            Rectangle()
                                                .frame(height: 30)
                                                .foregroundStyle(Color.black)
                                                .opacity(imageScales[index] == 1 ? 0.4 : 0.2)
                                            Text("Sumeru【Genshin Impact】")
                                                .font(.footnote)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                                .foregroundStyle(Color(white: imageScales[index] == 1 ? 0.7 : 0.9))
                                        }
                                        .animation(.default, value: imageScales)
                                    }
                                }
                                .animation(.default, value: viewModel.isFilterReveal)
                                .onTapGesture {
                                    withAnimation(.default.speed(2)) {
                                        selectedIndex = index
                                    }
                                }
                                .onHover {
                                    if $0 {
                                        imageScales[index] = 1.2
                                    } else {
                                        imageScales[index] = 1.0
                                    }
                                }
                            }
                        }
                        .padding(.trailing)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.leading, viewModel.isFilterReveal ? 10 : 0)
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
                }
                .lineLimit(1)
                .animation(.default, value: viewModel.isFilterReveal)
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
                        // MARK: Properties
                        HStack(spacing: 3) {
                            Text("Properties")
                            VStack {
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color.accentColor)
                            }
                        }
                        VStack(spacing: 16) {
                            ColorPicker(selection: .constant(.red), supportsOpacity: true) {
                                HStack {
                                    Label("Scheme Color", systemImage: "paintpalette.fill")
                                    Spacer()
                                }
                            }
                            HStack {
                                Label("Volume", systemImage: "speaker.wave.3.fill")
                                Spacer()
                                Slider(value: $imageScales.last!, in: 0...1).frame(width: 100)
                                Text(String(format: "%.0f", imageScales.last! * 100))
                                    .frame(width: 25)
                            }
                            HStack {
                                Label("Playback Rate", systemImage: "play.fill")
                                Spacer()
                                Slider(value: $imageScales.last!, in: 0...1).frame(width: 100)
                                Text(String(format: "%.0f", imageScales.last! * 100))
                                    .frame(width: 25)
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
        .sheet(isPresented: $isDisplaySettingsReveal) {
            VStack(spacing: 20) {
                Button {
                    isDisplaySettingsReveal = false
                } label: {
                    Image(systemName: "chevron.up")
                        .font(.largeTitle)
                        .bold()
                }
                .buttonStyle(.link)
                Text("Choose Display")
                    .font(.largeTitle)
                
                VStack(spacing: 5) {
                    Picker(selection: .constant(0)) {
                        Text("Wallpaper Per Display").tag(0)
                        Text("").tag(1)
                    } label: { }
                    HStack(spacing: 5) {
                        Button {
                            
                        } label: {
                            Label("Split", systemImage: "scissors")
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            
                        } label: {
                            Label("Group", systemImage: "square.on.square.squareshape.controlhandles")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    HStack(spacing: 5) {
                        Button {
                            
                        } label: {
                            Label("Load Profile", systemImage: "doc.text.fill")
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            
                        } label: {
                            Label("Save Profile", systemImage: "")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                Image("sumeru")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .overlay {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("2048x2048 MacBook Pro 14''")
                                    .font(.footnote)
                                    .foregroundStyle(Color.white)
                                    .background(Color.secondary)
                                Spacer()
                                Image(systemName: "speaker.wave.3.fill")
                                    .padding(5)
                                    .background(Color.secondary)
                            }
                            Spacer()
                        }
                        .padding(3)
                        .border(Color.accentColor, width: 3)
                    }
                HStack {
                    Button("Change Wallpaper") { }
                        .buttonStyle(.borderedProminent)
                    Button("Remove Wallpaper") { }
                }
                Spacer()
            }
            .padding()
            .frame(width: 520, height: 450)
        }
        .frame(minWidth: 800, minHeight: 600)
        .padding(.top)
    }
}

// MARK: - View Modifiers Extension
struct SelectedItem: ViewModifier {
    var selected: Bool
    
    init(_ selected: Bool) {
        self.selected = selected
    }
    
    func body(content: Content) -> some View {
        return content
            .border(Color.accentColor, width: selected ? 3 : 0)
    }
}

extension View {
    func selected(_ selected: Bool = true) -> some View {
        return modifier(SelectedItem(selected))
    }
}
// MARK: -
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
