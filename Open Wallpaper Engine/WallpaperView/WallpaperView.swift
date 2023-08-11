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
