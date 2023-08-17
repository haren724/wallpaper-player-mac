//
//  VideoWallpaperViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/14.
//

import AVKit
import SwiftUI

class VideoWallpaperViewModel: ObservableObject {
    @Published var player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemWillSleep), name: NSWorkspace.screensDidSleepNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemDidWake), name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func systemWillSleep(notification: Notification) {
        // Handle going to sleep
        print("System is going to sleep")
        // Update your SwiftUI state here if needed
        self.player.pause()
    }
        
    @objc func systemDidWake(notification: Notification) {
        // Handle waking up
        print("System woke up from sleep")
        // Update your SwiftUI state here if needed
        self.player.play()
    }
}
