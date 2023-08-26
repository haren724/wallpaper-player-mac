//
//  ExplorerTopBar.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct ExplorerTopBar: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    
    @EnvironmentObject var globalSettingsViewModel: GlobalSettingsViewModel
    
    init(contentViewModel viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
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
            if globalSettingsViewModel.settings.autoRefresh {
                Button {
                    viewModel.refresh()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
            }
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
    }
}
