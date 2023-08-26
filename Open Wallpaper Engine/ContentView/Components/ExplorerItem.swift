//
//  ExplorerItem.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/25.
//

import SwiftUI

struct ExplorerItem: SubviewOfContentView {
    
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    var wallpaper: WEWallpaper
    var index: Int
    
    var body: some View {
        GifImage(contentsOf: { (url: URL) in
            if let selectedProject = try? JSONDecoder()
                .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                return url.appending(path: selectedProject.preview)
            }
            return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
        }(wallpaper.wallpaperDirectory))
        .resizable()
        .scaleEffect(viewModel.imageScaleIndex == index ? 1.2 : 1.0)
        .clipShape(Rectangle())
        .border(Color.accentColor, width: viewModel.imageScaleIndex == index ? 1.0 : 0)
        .selected(index == viewModel.selectedIndex)
        .overlay {
            VStack {
                Spacer()
                Text(wallpaper.project.title)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .background(Color(white: 0, opacity: viewModel.imageScaleIndex == index ? 0.4 : 0.2))
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(white: viewModel.imageScaleIndex == index ? 0.9 : 0.7))
            }
        }
        .onTapGesture {
            withAnimation(.default.speed(2)) {
                viewModel.selectedIndex = index
                wallpaperViewModel.currentWallpaper = wallpaper
            }
        }
        .onHover { onHover in
            withAnimation {
                if onHover {
                    viewModel.imageScaleIndex = index
                } else {
                    viewModel.imageScaleIndex = -1
                }
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}
