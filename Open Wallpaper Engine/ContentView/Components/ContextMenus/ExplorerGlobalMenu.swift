//
//  ExplorerGlobalMenu.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct ExplorerGlobalMenu: SubviewOfContentView {
    
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    init(contentViewModel viewModel: ContentViewModel, wallpaperViewModel: WallpaperViewModel) {
        self.wallpaperViewModel = wallpaperViewModel
        self.viewModel = viewModel
    }
    
    var body: some View {
        Section {
            Button {
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path(percentEncoded: false))
            } label: {
                Label("Open All in Finder", systemImage: "folder.badge.gearshape")
            }
            Menu("View") {
                Section {
                    Picker("Icon Size", selection: $viewModel.explorerIconSize) {
                        Text("Small Icons").tag(Double(100))
                        Text("Medium Icons").tag(Double(125))
                        Text("Large Icons").tag(Double(150))
                    }
                    .pickerStyle(.inline)
                }
                Section {
                    Picker("Titles per page", selection: $viewModel.wallpapersPerPage) {
                        Text("10 per page").tag(10)
                        Text("25 per page").tag(25)
                        Text("50 per page").tag(50)
                        Text("1 per page (developer)").tag(1)
                        Text("1 per page (developer)").tag(2)
                    }
                    .pickerStyle(.inline)
                }
            }
        }
        .labelStyle(.titleAndIcon)
    }
}
