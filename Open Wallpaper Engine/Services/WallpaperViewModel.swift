//
//  WallpaperViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/14.
//

import SwiftUI

/// Provide Wallpaper Database for WallpaperView and ContentView etc.
class WallpaperViewModel: ObservableObject {
    @Published var nextCurrentWallpaper: WEWallpaper =
    WEWallpaper(using: .invalid, where: Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!) {
        willSet {
            if ["web", "application"].contains(newValue.project.type) {
                if let trustedWallpapers = UserDefaults.standard.array(forKey: "TrustedWallpapers") as? [String],
                   trustedWallpapers.contains(newValue.wallpaperDirectory.path(percentEncoded: false)) {
                    self.currentWallpaper = newValue
                } else {
                    AppDelegate.shared.contentViewModel.warningUnsafeWallpaperModal(which: newValue)
                }
            } else {
                self.currentWallpaper = newValue
            }
        }
    }
    
    @Published var currentWallpaper: WEWallpaper
    {
        didSet { UserDefaults.standard.set(try! JSONEncoder().encode(currentWallpaper), forKey: "CurrentWallpaper") }
    }
    
    var lastPlayRate: Float = 1.0
    @Published public var playRate: Float = 1.0 {
        willSet {
            if newValue == 0.0 {
                for (index, item) in AppDelegate.shared.statusItem.menu!.items.enumerated() {
                    if item.title == "Pause" {
                        AppDelegate.shared.statusItem.menu!.items[index] =
                            .init(title: "Resume", systemImage: "play.fill", action: #selector(AppDelegate.shared.resume), keyEquivalent: "")
                    }
                }
            } else {
                for (index, item) in AppDelegate.shared.statusItem.menu!.items.enumerated() {
                    if item.title == "Resume" {
                        AppDelegate.shared.statusItem.menu!.items[index] =
                            .init(title: "Pause", systemImage: "pause.fill", action: #selector(AppDelegate.shared.pause), keyEquivalent: "")
                    }
                }
            }
        }
        didSet {
            self.lastPlayRate = oldValue
        }
    }
    
    var lastPlayVolume: Float = 1.0
    @Published public var playVolume: Float = 1.0 {
        willSet {
            if newValue == 0.0 {
                for (index, item) in AppDelegate.shared.statusItem.menu!.items.enumerated() {
                    if item.title == "Mute" {
                        AppDelegate.shared.statusItem.menu!.items[index] =
                            .init(title: String(localized: "Unmute"), systemImage: "speaker.fill", action: #selector(AppDelegate.shared.unmute), keyEquivalent: "")
                    }
                }
            } else {
                for (index, item) in AppDelegate.shared.statusItem.menu!.items.enumerated() {
                    if item.title == "Unmute" {
                        AppDelegate.shared.statusItem.menu!.items[index] =
                            .init(title: String(localized: "Mute"), systemImage: "speaker.slash.fill", action: #selector(AppDelegate.shared.mute), keyEquivalent: "")
                    }
                }
            }
        }
        didSet {
            self.lastPlayVolume = oldValue
        }
    }
    
    init() {
        if let json = UserDefaults.standard.data(forKey: "CurrentWallpaper"),
           let wallpaper = try? JSONDecoder().decode(WEWallpaper.self, from: json) {
            currentWallpaper = wallpaper
        } else {
            currentWallpaper = WEWallpaper(using: .invalid, where: Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!)
        }
    }
}
