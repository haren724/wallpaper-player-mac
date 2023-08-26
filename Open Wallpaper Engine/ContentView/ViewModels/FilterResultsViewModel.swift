//
//  FilterResultsViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

typealias FilterResultsViewModel = ContentViewModel

protocol FilterResultsModel: OptionSet where Element == Self, RawValue == Int {
    static var allOptions: [String] { get }
}

struct FRShowOnly: OptionSet {
    let rawValue: Int
    
    static let allOptions = [
        ("Approved", "trophy.fill"),
        ("My Favourites", "heart.fill"),
        ("Mobile Compatible", "iphone.gen3"),
        ("Audio Responsive", ""),
        ("Customizable", "")
    ]
    
    static let approved             = FRShowOnly(rawValue: 1 << 0)
    static let myFavourites         = FRShowOnly(rawValue: 1 << 1)
    static let mobileCompatible     = FRShowOnly(rawValue: 1 << 2)
    static let audioResponsive      = FRShowOnly(rawValue: 1 << 3)
    static let customizable         = FRShowOnly(rawValue: 1 << 4)
    
    static let all: FRShowOnly = [.approved, myFavourites, mobileCompatible, .audioResponsive, .customizable]
    static let none: FRShowOnly = []
}

struct FRType: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "Scene",
        "Video",
        "Web",
        "Application",
        "Wallpaper",
        "Preset"
    ]
    
    static let scene            = FRType(rawValue: 1 << 0)
    static let video            = FRType(rawValue: 1 << 1)
    static let web              = FRType(rawValue: 1 << 2)
    static let application      = FRType(rawValue: 1 << 3)
    static let wallpaper        = FRType(rawValue: 1 << 4)
    static let preset           = FRType(rawValue: 1 << 5)
    
    static let all: FRType      = [.scene, .video, .web, .application, .wallpaper, .preset]
    static let none: FRType     = []
}

struct FRAgeRating: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "Everyone",
        "Partial Nudity",
        "Mature"
    ]
    
    static let everyone             = FRAgeRating(rawValue: 1 << 0)
    static let partialNudity        = FRAgeRating(rawValue: 1 << 1)
    static let mature               = FRAgeRating(rawValue: 1 << 2)
    
    static let all: FRAgeRating     = [.everyone, .partialNudity, .mature]
    static let none: FRAgeRating    = []
}

struct FRWidescreenResolution: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "StandardDefinition",
        "1280x720",
        "1920x1080-FullHD",
        "2560x1440",
        "3840x2160-4K"
    ]
    
    static let standardDefinition   = Self.init(rawValue: 1 << 0)
    static let resolution1280x720   = Self.init(rawValue: 1 << 1)
    static let resolution1920x1080  = Self.init(rawValue: 1 << 2)
    static let resolution2560x1440  = Self.init(rawValue: 1 << 3)
    static let resolution3840x2160  = Self.init(rawValue: 1 << 4)
    
    static let all: Self            = [.standardDefinition, resolution1280x720, resolution1920x1080, .resolution2560x1440, .resolution3840x2160]
    static let none: Self           = []
}

struct FRUltraWidescreenResolution: FilterResultsModel {
    let rawValue: Int
    
    
    static let allOptions: [String] = [
        "Ultrawide Standard",
        "2560x1080",
        "3440x1440",
    ]
    
    static let ultrawideStandard    = FRUltraWidescreenResolution(rawValue: 1 << 0)
    static let resolution2560x1080  = FRUltraWidescreenResolution(rawValue: 1 << 1)
    static let resolution3440x1440  = FRUltraWidescreenResolution(rawValue: 1 << 2)
    
    static let all: FRUltraWidescreenResolution = [.ultrawideStandard, resolution2560x1080, .resolution3440x1440]
    static let none: FRUltraWidescreenResolution = []
}

struct FRDualscreenResolution: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions: [String] = [
        "Dual Standard",
        "3840x1080",
        "5120x1440",
        "7680x2160"
    ]
    
    static let dualStandard         = Self.init(rawValue: 1 << 0)
    static let resolution3840x1080  = Self.init(rawValue: 1 << 1)
    static let resolution5120x1440  = Self.init(rawValue: 1 << 2)
    static let resolution7680x2160  = Self.init(rawValue: 1 << 3)
    
    static let all: Self = [.dualStandard, .resolution3840x1080, .resolution5120x1440, .resolution7680x2160]
    static let none: Self = []
}

struct FRTriplescreenResolution: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions: [String] = [
            "Triple Standard",
            "4096x768",
            "5760x1080",
            "7680x1440",
            "11520x2160"
        ]
    
    static let tripleStandard        = FRTriplescreenResolution(rawValue: 1 << 0)
    static let resolution4096x768    = FRTriplescreenResolution(rawValue: 1 << 1)
    static let resolution5760x1080   = FRTriplescreenResolution(rawValue: 1 << 2)
    static let resolution7680x1440   = FRTriplescreenResolution(rawValue: 1 << 3)
    static let resolution11520x2160  = FRTriplescreenResolution(rawValue: 1 << 4)
    
    static let all: FRTriplescreenResolution = [.tripleStandard, resolution4096x768, resolution5760x1080, resolution7680x1440, resolution11520x2160]
    static let none: FRTriplescreenResolution = []
}

struct FRPortraitScreenResolution: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "PotraitStandard",
        "720x1280",
        "1080x1920",
        "1440x2560",
        "2160x3840"
    ]
    
    static let portraitStandard     = Self.init(rawValue: 1 << 0)
    static let resolution720x1280   = Self.init(rawValue: 1 << 1)
    static let resolution1080x1920  = Self.init(rawValue: 1 << 2)
    static let resolution1440x2560  = Self.init(rawValue: 1 << 3)
    static let resolution2160x3840  = Self.init(rawValue: 1 << 4)
    
    static let all: Self            = [.portraitStandard, .resolution720x1280, .resolution1080x1920, .resolution1440x2560, .resolution2160x3840]
    static let none: Self           = []
}

struct FRMiscResolution: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "OtherResolution",
        "DynamicResolution"
    ]
    
    static let otherResolution     = Self.init(rawValue: 1 << 0)
    static let dynamicResolution   = Self.init(rawValue: 1 << 1)
    
    static let all: Self           = [.otherResolution, .dynamicResolution]
    static let none: Self          = []
}

struct FRSource: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "Official",
        "Workshop",
        "MyWallpapers"
    ]
    
    static let official        = Self.init(rawValue: 1 << 0)
    static let workshop        = Self.init(rawValue: 1 << 1)
    static let myWallpapers    = Self.init(rawValue: 1 << 2)
    
    static let all: Self       = [.official, .workshop, .myWallpapers]
    static let none: Self      = []
}

struct FRTag: FilterResultsModel {
    let rawValue: Int
    
    static let allOptions = [
        "Abstract",
        "Animal",
        "Anime",
        "Cartoon",
        "CGI",
        "Cyberpunk",
        "Fantasy",
        "Game",
        "Girls",
        "Guys",
        "Landscape",
        "Medieval",
        "Memes",
        "MMD",
        "Music",
        "Nature",
        "PixelArt",
        "Relaxing",
        "Retro",
        "Sci-Fi",
        "Sports",
        "Technology",
        "Television",
        "Vehicle",
        "UnspecifiedGenre"
    ]
    
    static let abstract             = FRTag(rawValue: 1 << 0)
    static let animal               = FRTag(rawValue: 1 << 1)
    static let anime                = FRTag(rawValue: 1 << 2)
    static let cartoon              = FRTag(rawValue: 1 << 3)
    static let cgi                  = FRTag(rawValue: 1 << 4)
    static let cyberpunk            = FRTag(rawValue: 1 << 5)
    static let fantasy              = FRTag(rawValue: 1 << 6)
    static let game                 = FRTag(rawValue: 1 << 7)
    static let girls                = FRTag(rawValue: 1 << 8)
    static let guys                 = FRTag(rawValue: 1 << 9)
    static let landscape            = FRTag(rawValue: 1 << 10)
    static let medieval             = FRTag(rawValue: 1 << 11)
    static let memes                = FRTag(rawValue: 1 << 12)
    static let mmd                  = FRTag(rawValue: 1 << 13)
    static let music                = FRTag(rawValue: 1 << 14)
    static let nature               = FRTag(rawValue: 1 << 15)
    static let pixelArt             = FRTag(rawValue: 1 << 16)
    static let relaxing             = FRTag(rawValue: 1 << 17)
    static let retro                = FRTag(rawValue: 1 << 18)
    static let sciFi                = FRTag(rawValue: 1 << 19)
    static let sports               = FRTag(rawValue: 1 << 20)
    static let technology           = FRTag(rawValue: 1 << 21)
    static let television           = FRTag(rawValue: 1 << 22)
    static let vehicle              = FRTag(rawValue: 1 << 23)
    static let unspecifiedGenre     = FRTag(rawValue: 1 << 24)
    
    static let all: FRTag = [
        .abstract, .animal, .anime, .cartoon, .cgi, .cyberpunk, .fantasy, .game, .girls,
        .guys, .landscape, .medieval, .memes, .mmd, .music, .nature, .pixelArt, .relaxing,
        .retro, .sciFi, .sports, .technology, .television, .vehicle, .unspecifiedGenre
    ]
    static let none: FRTag = []
}
