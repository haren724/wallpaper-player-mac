//
//  WallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import Cocoa
import SwiftUI

// Provide Wallpaper Database for WallpaperView and ContentView etc.
class WallpaperViewModel: ObservableObject {
    @AppStorage("SortingBy") var sortingBy: WEWallpaperSortingMethod = .name
    @AppStorage("SortingSequence") var sortingSequence: WEWallpaperSortingSequence = .increased
    
    @AppStorage("WallpapersPerPage") var wallpapersPerPage: Int = 1
    
    /// current page index number is starting from '1'
    @Published public var currentPage: Int = 1 {
        willSet {
            self.currentPage = newValue > self.maxPage ? self.maxPage : newValue
        }
    }
    
    private var maxPage: Int {
        Int(self.allWallpapers.count / self.wallpapersPerPage) + 1
    }
    
    private var urls: [URL] {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ) else {
            return []
        }
        
        return contents.filter { url in
            url.hasDirectoryPath
        }
    }
    
    private var allWallpapers: [WEWallpaper] {
        if let wallpapers = try? self.urls.map({ url in
            let project = try JSONDecoder().decode(WEProject.self, from: try Data(contentsOf: url))
            return WEWallpaper(using: project, where: url)
        }) {
            return wallpapers
        }
        else {
            return []
        }
    }
    
    public var wallpapers: [WEWallpaper] {
        let startIndex = (self.currentPage - 1) * self.wallpapersPerPage
        return Array(self.allWallpapers[startIndex..<self.allWallpapers.endIndex].prefix(self.wallpapersPerPage))
    }
}


struct WallpaperView: View {
    @ObservedObject var viewModel: WallpaperViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VideoWallpaperView(url: $contentViewModel.selectedURL)
    }
}
