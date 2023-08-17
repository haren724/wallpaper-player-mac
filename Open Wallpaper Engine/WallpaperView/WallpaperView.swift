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
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VideoWallpaperView(viewModel: viewModel, url: contentViewModel.selectedURL)
    }
}
