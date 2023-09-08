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
        ZStack(alignment: .bottom) {
            GifImage(contentsOf: { (url: URL) in
                if let selectedProject = try? JSONDecoder()
                    .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                    return url.appending(path: selectedProject.preview)
                }
                return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
            }(wallpaper.wallpaperDirectory))
            .resizable()
            .scaleEffect(viewModel.imageScaleIndex == index ? 1.2 : 1.0)
            .aspectRatio(1.0, contentMode: .fit)
            .clipped()
            
            Text(wallpaper.project.title)
                .lineLimit(2)
                .frame(maxWidth: .infinity, minHeight: 30)
                .padding(4)
                .background(Color(white: 0, opacity: viewModel.imageScaleIndex == index ? 0.4 : 0.2))
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(white: viewModel.imageScaleIndex == index ? 0.9 : 0.7))
            
            Spacer()
                .onHover { onHover in
                    if onHover {
                        viewModel.imageScaleIndex = index
                    } else {
                        viewModel.imageScaleIndex = -1
                    }
                }
        }
        .selected(wallpaper.wallpaperDirectory == wallpaperViewModel.currentWallpaper.wallpaperDirectory)
        .border(Color.accentColor, width: viewModel.imageScaleIndex == index ? 1.0 : 0)
        .onTapGesture {
//            viewModel.selectedIndex = index
            wallpaperViewModel.nextCurrentWallpaper = wallpaper
        }
    }
}
