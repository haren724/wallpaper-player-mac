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
        Text("Hello")
    }
}

class WallpaperViewController: NSViewController {
    
    private var player: AVPlayer!
    private var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAVPlayer()
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
        self.player = AVPlayer(url: Bundle.main.url(forResource: "sumeruWP_4", withExtension: "mp4")!)
        self.playerView = AVPlayerView()
        self.view = self.playerView
        self.view.frame = NSScreen.main!.frame
        self.playerView.player = self.player
        self.playerView.videoGravity = .resizeAspectFill
        self.player.play()
    }
}
