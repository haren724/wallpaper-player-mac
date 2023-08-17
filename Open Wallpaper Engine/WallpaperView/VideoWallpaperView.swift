//
//  VideoWallpaperView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/13.
//

import Cocoa
import SwiftUI
import AVKit

struct VideoWallpaperView: NSViewRepresentable {
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    @ObservedObject var viewModel: VideoWallpaperViewModel
    
    init(viewModel: WallpaperViewModel, url: URL) {
        self.wallpaperViewModel = viewModel
        self.viewModel = VideoWallpaperViewModel(url: url)
    }
    
    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = viewModel.player
        
        // make the video boundary extends to fit the full screen without black background border
        view.videoGravity = .resizeAspectFill
        
        // hide any unneeded ui component, we want just the video output
        view.controlsStyle = .none
        
        // make sure this video player won't show any info in the system control center
        view.updatesNowPlayingInfoCenter = false
        
        // mark the flag as unneeded, improve performance and reduce power drain
        view.allowsVideoFrameAnalysis = false
        
        return view
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        if nsView.player != viewModel.player {
            nsView.player = viewModel.player
        }
        
        nsView.player?.rate = wallpaperViewModel.playRate
        nsView.player?.volume = wallpaperViewModel.playVolume
    }
    
//    func makeNSViewController(context: Context) -> VideoWallpaperViewController {
//        VideoWallpaperViewController(url: url)
//    }
//
//    func updateNSViewController(_ nsViewController: VideoWallpaperViewController, context: Context) {
//        if nsViewController.url != url {
//            nsViewController.url = url
//        }
//
//        nsViewController.player.rate = viewModel.playRate
//        nsViewController.player.volume = viewModel.playVolume
//    }
}

//struct VideoWallpaperView: NSViewControllerRepresentable {
//    @ObservedObject var viewModel: WallpaperViewModel
//    @Binding var url: URL
//    
//    func makeNSViewController(context: Context) -> VideoWallpaperViewController {
//        VideoWallpaperViewController(url: url)
//    }
//    
//    func updateNSViewController(_ nsViewController: VideoWallpaperViewController, context: Context) {
//        if nsViewController.url != url {
//            nsViewController.url = url
//        }
//        
//        nsViewController.player.rate = viewModel.playRate
//        nsViewController.player.volume = viewModel.playVolume
//    }
//}

class VideoWallpaperViewController: NSViewController {
    
    public var player = AVPlayer()
    public var playerView: AVPlayerView!
    
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


