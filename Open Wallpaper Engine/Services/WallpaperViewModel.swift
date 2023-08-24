//
//  WallpaperViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/14.
//

import SwiftUI

/// Provide Wallpaper Database for WallpaperView and ContentView etc.
class WallpaperViewModel: ObservableObject {
    @AppStorage("SortingBy") var sortingBy: WEWallpaperSortingMethod = .name
    @AppStorage("SortingSequence") var sortingSequence: WEWallpaperSortingSequence = .increased
    
    @AppStorage("FRShowOnly")                   public var showOnly = FRShowOnly.all
    @AppStorage("FRType")                       public var type = FRType.all
    @AppStorage("FRAgeRating")                  public var ageRating = FRAgeRating.all
    @AppStorage("FRWidescreenResolution")       public var widescreenResolution = FRWidescreenResolution.all
    @AppStorage("FRUltraWidescreenResolution")  public var ultraWidescreenResolution = FRUltraWidescreenResolution.all
    @AppStorage("FRDualscreenResolution")       public var dualscreenResolution = FRDualscreenResolution.all
    @AppStorage("FRTriplescreenResolution")     public var triplescreenResolution = FRTriplescreenResolution.all
    @AppStorage("FRPortraitScreenResolution")   public var potraitscreenResolution = FRPortraitScreenResolution.all
    @AppStorage("FRMiscResolution")             public var miscResolution = FRMiscResolution.all
    @AppStorage("FRSource")                     public var source = FRSource.all
    @AppStorage("FRTag")                        public var tag = FRTag.all
    
    @AppStorage("WallpapersPerPage") var wallpapersPerPage: Int = 2
    
    /// current page index number is starting from '1'
    @Published public var currentPage: Int = 1 
//    {
//        willSet {
//            self.currentPage = newValue > self.maxPage ? self.maxPage : newValue
//        }
//    }
    
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
                            .init(title: "Unmute", systemImage: "speaker.fill", action: #selector(AppDelegate.shared.unmute), keyEquivalent: "")
                    }
                }
            } else {
                for (index, item) in AppDelegate.shared.statusItem.menu!.items.enumerated() {
                    if item.title == "Unmute" {
                        AppDelegate.shared.statusItem.menu!.items[index] =
                            .init(title: "Mute", systemImage: "speaker.slash.fill", action: #selector(AppDelegate.shared.mute), keyEquivalent: "")
                    }
                }
            }
        }
        didSet {
            self.lastPlayVolume = oldValue
        }
    }
    
    /// Caculates the maximium possible page index for all wallpapers in your application wallpaper directory
    var maxPage: Int {
        Int(self.filteredWallpapers.count / self.wallpapersPerPage)
    }
    
    private var urls: [URL] {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        ) else {
            return []
        }
        
        return contents
    }
    
    /// Show all the wallpaper inside application wallpaper directory, without being filtered
    private var allWallpapers: [WEWallpaper] {
        self.urls.map({ url in
            if let data = try? Data(contentsOf: url.appending(path: "project.json")), let project = try? JSONDecoder().decode(WEProject.self, from: data) {
                return WEWallpaper(using: project, where: url)
            } else {
                return WEWallpaper(using: .invalid, where: url)
            }
        })
    }
    
    private var filteredWallpapers: [WEWallpaper] {
        let result = allWallpapers.filter { wallpaper in
            
            // Age Rating
            var ageRating: FRAgeRating
            switch wallpaper.project.contentrating {
            case "Everyone":
                ageRating = .everyone
            case "Questionable":
                ageRating = .partialNudity
            case "Mature":
                ageRating = .mature
            default:
                ageRating = .none
            }
            return self.ageRating.contains(ageRating)
        }
        return result
    }
    
    /// Provide wallpapers information for UI, being filtered by FilterResults and divided in pages
    public var wallpapers: [WEWallpaper] {
        let startIndex = (self.currentPage - 1) * self.wallpapersPerPage
        let filteredWallpapers = self.filteredWallpapers
        let clip = filteredWallpapers[startIndex..<filteredWallpapers.endIndex]
        return Array(clip.prefix(self.wallpapersPerPage))
    }
    
    /// Provide a filter reset to default function, usually being used to show all wallpapers without filtered
    public func reset() {
        self.showOnly                   = .none // notice it's show ONLY, it acts oppositely to the others
        self.type                       = .all
        self.ageRating                  = .all
        self.type                       = .all
        self.ageRating                  = .all
        self.widescreenResolution       = .all
        self.ultraWidescreenResolution  = .all
        self.dualscreenResolution       = .all
        self.triplescreenResolution     = .all
        self.potraitscreenResolution    = .all
        self.miscResolution             = .all
        self.source                     = .all
        self.tag                        = .all
    }
}
