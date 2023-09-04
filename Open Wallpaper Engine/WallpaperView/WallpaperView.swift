//
//  WallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import Cocoa
import SwiftUI

struct WallpaperView: View {
    @ObservedObject var viewModel: WallpaperViewModel
    
    var body: some View {
        switch viewModel.currentWallpaper.project.type.lowercased() {
        case "video":
            VideoWallpaperView(wallpaperViewModel: viewModel)
//        case "scene":
//            Text("?")
        case "web":
            WebWallpaperView(wallpaperViewModel: viewModel)
        default:
            EmptyView()
        }
    }
}
