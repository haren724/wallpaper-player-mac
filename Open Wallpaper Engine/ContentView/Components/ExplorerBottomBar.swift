//
//  ExplorerBottomBar.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct ExplorerBottomBar: View {
    var body: some View {
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
            .disabled(true)
            HStack {
                Button { } label: {
                    Label("Wallpaper Editor", systemImage: "pencil.and.ruler.fill")
                        .frame(width: 220)
                }
                .buttonStyle(.borderedProminent)
                .disabled(true)
                Button {
                    AppDelegate.shared.openImportFromFolderPanel()
                } label: {
                    Label("Open Wallpaper", systemImage: "arrow.up.bin.fill")
                        .frame(width: 220)
                }
                Spacer()
            }
        }    }
}
