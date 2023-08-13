//
//  WallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import Cocoa
import SwiftUI
import AVKit

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
        WallpaperPlayerView(url: $contentViewModel.selectedURL)
    }
}

struct WallpaperPlayerView: NSViewControllerRepresentable {
    @Binding var url: URL
    
    func makeNSViewController(context: Context) -> WallpaperViewController {
        WallpaperViewController(url: url)
    }
    
    func updateNSViewController(_ nsViewController: WallpaperViewController, context: Context) {
        nsViewController.url = url
    }
}

class WallpaperViewController: NSViewController {
    
    private var player: AVPlayer!
    private var playerView: AVPlayerView!
    
    private var _url: URL!
    public var url: URL {
        get {
            self._url != nil ? _url : URL(fileURLWithPath: "")
        }
        set {
            self._url = newValue
            print(newValue)
            self.player = AVPlayer(url: _url)
            self.playerView.player = self.player
            self.player.play()
        }
    }
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self._url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.setAVPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    public func pause() {
        self.player.pause()
    }
    
    public func resume() {
        self.player.play()
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        print("replaying...")
        // 重新播放视频
        self.player.seek(to: CMTime.zero)
        self.player.play()
    }
    
    @objc private func playerDidStopPlaying(_ notification: Notification) {
        print("stopped, trying to resume...")
        // 重新播放视频
        self.player.play()
    }
    
    private func setAVPlayer() {
        self.playerView = AVPlayerView()
        self.view = self.playerView
        self.view.frame = NSScreen.main!.frame
        self.playerView.videoGravity = .resizeAspectFill
    }
}
