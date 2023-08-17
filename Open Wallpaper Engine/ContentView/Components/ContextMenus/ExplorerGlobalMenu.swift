//
//  ExplorerGlobalMenu.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct ExplorerGlobalMenu: View {
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    init(wallpaperViewModel: WallpaperViewModel) {
        self.wallpaperViewModel = wallpaperViewModel
    }
    
    var body: some View {
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
                        Picker("Titles per page", selection: $wallpaperViewModel.wallpapersPerPage) {
                            Text("10 per page").tag(10)
                            Text("25 per page").tag(25)
                            Text("50 per page").tag(50)
                            Text("1 per page (developer)").tag(1)
                            Text("1 per page (developer)").tag(2)
                        }
                    }
                }
            }
            .labelStyle(.titleAndIcon)
        
    }
}
