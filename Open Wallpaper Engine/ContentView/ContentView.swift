//
//  ContentView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

class ContentViewModel: ObservableObject {
    @AppStorage("FilterReveal") var isFilterReveal = false
    @AppStorage("WallpaperURLs") var wallpaperUrls = [URL]()
    
    @Published var importAlertPresented = false
    @Published var isStaging = true
    
    var importAlertError: WPImportError? = nil
    
    var wallpapers: [WEWallpaper] {
        get {
            if wallpaperUrls.isEmpty {
                
            }
            let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "2816680522")
            guard let wallpaper = try? WEWallpaper(wallpaperURL: url) else { return [] }
            return [wallpaper]
        }
    }
    
    func toggleFilter() {
        isFilterReveal.toggle()
    }
    
    func alertImportModal(which error: WPImportError) {
        self.importAlertError = error
        self.importAlertPresented = true
    }
}

struct GifImage: NSViewRepresentable {
    var gifName: String
    
    func makeNSView(context: Context) -> some NSView {
        let imageView = NSImageView(frame: NSRect(x: 407, y: 474, width: 92, height: 74))
        imageView.canDrawSubviewsIntoLayer = true
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        if let url = Bundle.main.url(forResource: self.gifName, withExtension: "gif") {
            if let image = NSImage(contentsOf: url) {
                let gifRep = image.representations[0] as? NSBitmapImageRep
                gifRep?.setProperty(.loopCount, withValue: 0)
                imageView.image = image
            }
        }
        return imageView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

struct FilterSection<Content>: View where Content: View {
    private let content: Content
    private let alignment: HorizontalAlignment
    private var spacing: CGFloat?
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
                        .font(.caption)
                        .rotationEffect(isExpanded ? .zero : .degrees(-90.0))
                        .animation(.spring(), value: isExpanded)
                    Text(self.titleKey)
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            if isExpanded {
                content.padding(.leading, (self.alignment == .leading) ? 10 : 0)
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var globalSettingsViewModel: GlobalSettingsViewModel
    
    @ObservedObject var viewModel: ContentViewModel
    @StateObject var filterResultsViewModel = FilterResultsViewModel()
    
    @State var isDropTargeted = false
    @State var isParseFinished = false
    @State var isFilterReveal = true
    @State var isDisplaySettingsReveal = false
    
    @State var imageScaleIndex: Int = -1
    @State var selectedIndex: Int!
    
    @State var isDockIconHidden = false
    
    @State var project: WEProject!
    @State var projectUrl: URL!
    @State var greet: String = "Hello, world!"
    
    var body: some View {
        ZStack {
            HSplitView {
                if viewModel.isStaging {
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
                                .fixedSize()
                                .buttonStyle(.plain)
                                Spacer()
                                    .frame(minWidth: 10)
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
                                .fixedSize()
                                .buttonStyle(.plain)
                            }
                            .offset(x: 0.5)
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
                                // MARK: Filter Results
                                FilterResults(viewModel: self.filterResultsViewModel)
                            }
                            .frame(width: viewModel.isFilterReveal ? 225 : 0)
                            .opacity(viewModel.isFilterReveal ? 1 : 0)
                            .animation(.spring(), value: viewModel.isFilterReveal)
                            ScrollView {
                                // MARK: Items
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))],
                                          alignment: .leading) {
                                    ForEach(0..<3) { index in
                                        GifImage(gifName: "preview")
                                            .frame(maxWidth: 150, maxHeight: 150)
                                            .scaleEffect(imageScaleIndex == index ? 1.2 : 1.0)
                                            .clipShape(Rectangle())
                                            .border(Color.accentColor, width: imageScaleIndex == index ? 1.0 : 0)
                                            .selected(index == selectedIndex)
                                            .animation(.spring(), value: imageScaleIndex == index ? 1.2 : 1.0)
                                            .overlay {
                                                VStack {
                                                    Spacer()
                                                    ZStack {
                                                        Rectangle()
                                                            .frame(height: 30)
                                                            .foregroundStyle(Color.black)
                                                            .opacity(imageScaleIndex == index ? 0.4 : 0.2)
                                                            .animation(.default, value: imageScaleIndex)
                                                        Text("Sumeru【Genshin Impact】")
                                                            .font(.footnote)
                                                            .lineLimit(2)
                                                            .multilineTextAlignment(.center)
                                                            .foregroundStyle(Color(white: imageScaleIndex == index ? 0.7 : 0.9))
                                                    }
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation(.default.speed(2)) {
                                                    selectedIndex = index
                                                }
                                            }
                                            .onHover { onHover in
                                                if onHover {
                                                    print(index)
                                                    imageScaleIndex = index
                                                }
                                            }
                                    }
                                    if viewModel.wallpapers.isEmpty {
                                        VStack {
                                            Text("Drag here to import wallpapers").font(.title)
                                                .lineLimit(nil)
                                        }
                                        .padding()
                                        .frame(width: 200, height: 200)
                                        .background(Color(nsColor: .controlBackgroundColor))
                                        .onTapGesture {
                                            print(String(describing: viewModel.wallpapers.first))
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
                                    } else {
                                        
                                    }
                                    
                                    //                            ForEach(viewModel.wallpapers) { wallpaper in
                                    //                                ZStack {
                                    //                                    GifImage(gifName: wallpaper.preview.filename ?? "")
                                    //                                            .resizable()
                                    //                                            .aspectRatio(contentMode: .fit)
                                    //                                            .scaleEffect(imageScaleIndex == index ? 1.2 : 1.0)
                                    //                                            .clipShape(Rectangle())
                                    //                                            .border(Color.accentColor, width: imageScaleIndex == index ? 1.0 : 0)
                                    //                                            .selected(index == selectedIndex ?? 0)
                                    //                                            .animation(.spring, value: imageScaleIndex == index ? 1.2 : 1.0)
                                    //                                    VStack {
                                    //                                        Spacer()
                                    //                                        ZStack {
                                    //                                            Rectangle()
                                    //                                                .frame(height: 30)
                                    //                                                .foregroundStyle(Color.black)
                                    //                                                .opacity(imageScaleIndex == index ? 0.4 : 0.2)
                                    //                                                .animation(.default, value: imageScaleIndex)
                                    //                                            Text("Sumeru【Genshin Impact】")
                                    //                                                .font(.footnote)
                                    //                                                .lineLimit(2)
                                    //                                                .multilineTextAlignment(.center)
                                    //                                                .foregroundStyle(Color(white: imageScaleIndex == index ? 0.7 : 0.9))
                                    //                                        }
                                    //                                    }
                                    //                                }
                                    //                                .onTapGesture {
                                    //                                    withAnimation(.default.speed(2)) {
                                    //                                        selectedIndex = index
                                    //                                    }
                                    //                                }
                                    //                                .onHover { onHover in
                                    //                                    if onHover {
                                    //                                        imageScaleIndex = index
                                    //                                    }
                                    //                                }
                                    //                            }
                                    //                        }
                                    //                        .padding(.trailing)
                                    //                        .frame(maxWidth: .infinity)
                                }
                            }
                            .contextMenu {
                                Section {
                                    Button {
                                        
                                    } label: {
                                        Label("Add to Playlist", systemImage: "plus")
                                    }
                                    Button {
                                        
                                    } label: {
                                        Label("Unsubscribe", systemImage: "xmark")
                                    }
                                    Button {
                                        
                                    } label: {
                                        Label("Add to Favorites", systemImage: "heart.fill")
                                    }
                                }
                                .labelStyle(.titleAndIcon)
                                Section {
                                    Button {
                                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path())
                                    } label: {
                                        Label("Open Wallpapers Folder in Finder", systemImage: "folder.badge.gearshape")
                                    }
                                    Picker("View", selection: .constant(0)) {
                                        Section {
                                            Button("Small Icons") {
                                                
                                            }
                                            Button("Small Icons") {
                                                
                                            }
                                            Button("Small Icons") {
                                                
                                            }
                                        }
                                        Section {
                                            Button("50 per Page") {
                                                
                                            }
                                            Button("100 per Page") {
                                                
                                            }
                                            Button("200 per Page") {
                                                
                                            }
                                        }
                                    }
                                }
                                .labelStyle(.titleAndIcon)
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
                                    GifImage(gifName: "preview")
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
                                        Slider(value: .constant(0.5), in: 0...1).frame(width: 100)
                                        Text(String(format: "%.0f", 0.5))
                                            .frame(width: 25)
                                    }
                                    HStack {
                                        Label("Playback Rate", systemImage: "play.fill")
                                        Spacer()
                                        Slider(value: .constant(0.5), in: 0...1).frame(width: 100)
                                        Text(String(format: "%.0f", 0.5))
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
        //                        self.mainWindowController.window.performClose(nil)
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
                    .frame(maxWidth: 320)
                }
            }
            .opacity(viewModel.isStaging ? 1 : 0)
            .blur(radius: viewModel.isStaging ? 0 : 2.0)
            if !viewModel.isStaging {
                HStack(spacing: 20) {
                    ProgressView()
                    Text("Loading...")
                        .font(.largeTitle)
                }
            }
        }
        .alert(isPresented: $viewModel.importAlertPresented, error: viewModel.importAlertError) {
            
        }
        .sheet(isPresented: $globalSettingsViewModel.isFirstLaunch) {
            FirstLaunchView()
                .environmentObject(globalSettingsViewModel)
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
        .frame(minWidth: 1000, minHeight: 400, idealHeight: 600)
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
            .environmentObject(GlobalSettingsViewModel())
    }
}
