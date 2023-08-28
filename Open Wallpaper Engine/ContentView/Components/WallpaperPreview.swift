//
//  WallpaperPreview.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct WallpaperPreview: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    @State var isEditingId = ""
    @State var title = ""
    
    init(contentViewModel viewModel: ContentViewModel, wallpaperViewModel: WallpaperViewModel) {
        self.viewModel = viewModel
        self.wallpaperViewModel = wallpaperViewModel
    }
    
    var wallpaperSize: String {
        guard let sizeBytes = try? wallpaperViewModel.currentWallpaper.wallpaperDirectory.directoryTotalAllocatedSize(includingSubfolders: true) 
        else {
            return "??? MB"
        }
        return ByteCountFormatter.string(fromByteCount: Int64(sizeBytes), countStyle: .file)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        GifImage(contentsOf: { (url: URL) in
                            if let selectedProject = try? JSONDecoder()
                                .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                                return url.appending(path: selectedProject.preview)
                            }
                            return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
                        }(wallpaperViewModel.currentWallpaper.wallpaperDirectory))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 280, height: 280)
                        HStack {
                            if isEditingId == "title" {
                                TextField("Wallpaper Title", text: $title)
                                    .onSubmit {
                                        var wallpaper = wallpaperViewModel.currentWallpaper
                                        
                                        wallpaper.project.title = title
                                        
                                        guard let data = try? JSONEncoder().encode(wallpaper.project) else { return }
                                        
                                        try? data.write(to: wallpaper.wallpaperDirectory.appending(path: "project.json"), options: .atomic)
                                        
                                        wallpaperViewModel.currentWallpaper = wallpaper
                                        
                                        isEditingId = ""
                                    }
                            } else {
                                Text(wallpaperViewModel.currentWallpaper.project.title.isEmpty ? "Untitled" : wallpaperViewModel.currentWallpaper.project.title)
                                    .frame(minWidth: 50)
                                    .id("title")
                                    .lineLimit(1)
                                    .onTapGesture(count: 2) {
                                        title = wallpaperViewModel.currentWallpaper.project.title
                                        isEditingId = "title"
                                    }
                                Image(systemName: "square.and.pencil")
                            }
                            
                        }
                    }
                    HStack {
                        Image("we.placeholder")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("Unkown Author")
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
                        Text(wallpaperViewModel.currentWallpaper.project.type)
                        Text(wallpaperSize)
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
                            Slider(value: $wallpaperViewModel.playVolume, in: 0...1).frame(width: 100)
                            Text(String(format: "%.0f", wallpaperViewModel.playVolume * 100) + "%")
                                .frame(width: 35)
                        }
                        HStack {
                            Label("Playback Rate", systemImage: "play.fill")
                            Spacer()
                            Slider(value: $wallpaperViewModel.playRate, in: 0...2, step: 0.1).frame(width: 100)
                            Text(String(format: "%.01fx", wallpaperViewModel.playRate))
                                .frame(width: 35)
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
                .padding([.horizontal, .top])
            }

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
    }
}

extension URL {
    /// check if the URL is a directory and if it is reachable
    func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }

    /// returns total allocated size of a the directory including its subFolders or not
    func directoryTotalAllocatedSize(includingSubfolders: Bool = false) throws -> Int? {
        guard try isDirectoryAndReachable() else { return nil }
        if includingSubfolders {
            guard
                let urls = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            return try urls.lazy.reduce(0) {
                    (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0) + $0
            }
        }
        return try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil).lazy.reduce(0) {
                 (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                    .totalFileAllocatedSize ?? 0) + $0
        }
    }
}

#Preview {
    ContentView(viewModel: .init(isStaging: true), wallpaperViewModel: .init())
        .environmentObject(GlobalSettingsViewModel())
}
