//
//  WallpaperExplorer.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct WallpaperExplorer: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    init(contentViewModel viewModel: ContentViewModel, wallpaperViewModel: WallpaperViewModel) {
        self.viewModel = viewModel
        self.wallpaperViewModel = wallpaperViewModel
    }
    
    var body: some View {
        ScrollView {
            // MARK: Items
            if viewModel.autoRefreshWallpapers.isEmpty {
                HStack {
                    Spacer()
                    Text("""
                        No wallpapers found for your search.
                        Expand or reset the categories in the filter sidebar or try another search term.
                        """)
                    .font(.title)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(10)
                    Spacer()
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 50)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.explorerIconSize, 
                                                       maximum: viewModel.explorerIconSize * 2)
                )], alignment: .leading) {
                    ForEach(Array(viewModel.autoRefreshWallpapers.enumerated()), id: \.0) { (index, wallpaper) in
                        ExplorerItem(viewModel: viewModel, wallpaperViewModel: wallpaperViewModel, wallpaper: wallpaper, index: index)
                            .contextMenu {
                                ExplorerItemMenu(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel, current: wallpaper)
                                    .onAppear {
                                        viewModel.hoveredWallpaper = wallpaper
                                    }
                                    .onDisappear {
                                        viewModel.hoveredWallpaper = nil
                                    }
                                ExplorerGlobalMenu(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                            }
                            .animation(.spring(), value: viewModel.imageScaleIndex)
                            .animation(.spring(), value: wallpaperViewModel.currentWallpaper.rawValue)
                    }
                }
                .padding(.trailing)
            }
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<viewModel.maxPage, id: \.self) { page in
                        Button("\(page + 1)") {
                            viewModel.currentPage = page + 1
                        }
                    }
                }
                .padding(.bottom)
            }
        }
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
