//
//  ExplorerItemMenu.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/29.
//

import SwiftUI

struct ExplorerItemMenu: SubviewOfContentView {
    
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    var hoveredWallpaper: WEWallpaper
    
    init(contentViewModel viewModel: ContentViewModel, wallpaperViewModel: WallpaperViewModel, current hoveredWallpaper: WEWallpaper) {
        self.wallpaperViewModel = wallpaperViewModel
        self.viewModel = viewModel
        self.hoveredWallpaper = hoveredWallpaper
    }
    
    var body: some View {
        Group {
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
            
            Section {
                Button {
                    
                } label: {
                    Label("Open in Workshop", systemImage: "cloud.fill")
                }
                Menu("Related Wallpapers") {
                    Link(destination: URL(string: "https://github.com/haren724/open-wallpaper-engine-mac")!) {
                        Label("Browse All By", systemImage: "person.fill")
                    }
                    Link(destination: URL(string: "https://github.com/haren724/open-wallpaper-engine-mac")!) {
                        Label("Browse Presets", systemImage: "cloud.fill")
                    }
                }
                Menu("Report & Block") {
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("Report", systemImage: "exclamationmark.triangle.fill")
                    }
                    Button {
                        
                    } label: {
                        Label("Manage Blocklist", systemImage: "hand.raised.fill")
                    }
                }
            }
            
            Section {
                Button {
                    
                } label: {
                    Label("Assign Hotkey", systemImage: "command.square")
                }
                Button {
                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: hoveredWallpaper.wallpaperDirectory.path())
                } label: {
                    Label("Open in Finder", systemImage: "folder.badge.gearshape")
                }
            }
        }
        .labelStyle(.titleAndIcon)
    }
}

#Preview {
    ContentView(viewModel: .init(isStaging: true), wallpaperViewModel: .init())
        .environmentObject(GlobalSettingsViewModel())
}
