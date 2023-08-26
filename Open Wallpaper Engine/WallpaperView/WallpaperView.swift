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
        switch viewModel.currentWallpaper.project.type {
        case "video":
            VideoWallpaperView(wallpaperViewModel: viewModel)
        case "scene":
            Text("?")
        default:
            VideoWallpaperView(wallpaperViewModel: WallpaperViewModel())
        }
    }
}
