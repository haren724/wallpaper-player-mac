//
//  FilterResultsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/29.
//

import SwiftUI
import Combine

enum GeneralControl {
    case all, none
}

protocol FilterResultsModel<ObjectType>: AnyObject, ObservableObject where ObjectType: ObservableObject {
    associatedtype ObjectType
    
    var parent: ObjectType? { get set }
    
    init()
    
    init(_ parent: ObjectType?)
    
    func reset(to resetValue: Bool)
}

extension FilterResultsModel {
    init(_ parent: ObjectType?) {
        self.init()
        self.parent = parent
    }
    
    func reset(to resetValue: Bool = true) {
        let mirror = Mirror(reflecting: self)
        for case let (label?, _) in mirror.children {
            if let boolValue = mirror.descendant(label) as? AppStorage<Bool> {
                boolValue.projectedValue.wrappedValue = resetValue
            }
        }
        
        guard let parent = self.parent else { return }
        (parent.objectWillChange as? ObservableObjectPublisher)?.send()
    }
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

struct FRType: OptionSet {
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

struct FRAgeRating: OptionSet {
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

class FRWidescreenResolution<ObjectType>: FilterResultsModel where ObjectType: ObservableObject {
    weak var parent: ObjectType?
    
    required init() {}
    
    @AppStorage("StandardDefinition") public var standardDefinition = true
    @AppStorage("1280x720") public var resolution1280x720 = true
    @AppStorage("1920x1080-FullHD") public var resolution1920x1080 = true
    @AppStorage("2560x1440") public var resolution2560x1440 = true
    @AppStorage("3840x2160-4K") public var resolution3840x2160 = true
}

class FRUltraWidescreenResolution<ObjectType>: FilterResultsModel where ObjectType: ObservableObject {
    weak var parent: ObjectType?
    
    required init() {}
    
    @AppStorage("UltrawideStandard") public var ultrawideStandard = true
    @AppStorage("2560x1080") public var resolution2560x1080 = true
    @AppStorage("3440x1440") public var resolution3440x1440 = true
    @AppStorage("DualStandard") public var dualStandard = true
    @AppStorage("3840x1080") public var resolution3840x1080 = true
    @AppStorage("5120x1440") public var resolution5120x1440 = true
    @AppStorage("7680x2160") public var resolution7680x2160 = true
}

class FRTriplescreenResolution<ObjectType>: FilterResultsModel where ObjectType: ObservableObject {
    weak var parent: ObjectType?
    
    required init() {}
    
    @AppStorage("TripleStandard") public var tripleStandard = true
    @AppStorage("4096x768") public var resolution4096x768 = true
    @AppStorage("5760x1080") public var resolution5760x1080 = true
    @AppStorage("7680x1440") public var resolution7680x1440 = true
    @AppStorage("11520x2160") public var resolution11520x2160 = true
}

class FRPotraitscreenResolution<ObjectType>: FilterResultsModel where ObjectType: ObservableObject {
    weak var parent: ObjectType?
    
    required init() {}
    
    @AppStorage("PotraitStandard") public var potraitStandard = true
    @AppStorage("720x1280") public var resolution720x1280 = true
    @AppStorage("1080x1920") public var resolution1080x1920 = true
    @AppStorage("1440x2560") public var resolution1440x2560 = true
    @AppStorage("2160x3840") public var resolution2160x3840 = true
}

class FRMiscResolution<ObjectType>: FilterResultsModel where ObjectType: ObservableObject {
    weak var parent: ObjectType?
    
    required init() {}
    
    @AppStorage("OtherResolution") public var otherResolution = true
    @AppStorage("DynamicResolution") public var dynamicResolution = true
}

class FRSource<ObjectType>: FilterResultsModel where ObjectType: ObservableObject {
    weak var parent: ObjectType?
    
    required init() {}
    
    @AppStorage("Official") public var official = true
    @AppStorage("Workshop") public var workshop = true
    @AppStorage("MyWallpapers") public var myWallpapers = true
}

struct FRTag: OptionSet {
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

// MARK: -
class FilterResultsViewModel: ObservableObject {
    @AppStorage("FRShowOnly") public var showOnly = FRShowOnly.all
    @AppStorage("FRType") public var type = FRType.all
    @AppStorage("FRAgeRating") public var ageRating = FRAgeRating.all
    @Published public var widescreenResolution = FRWidescreenResolution<FilterResultsViewModel>()
    @Published public var ultraWidescreenResolution = FRUltraWidescreenResolution<FilterResultsViewModel>()
    @Published public var triplescreenResolution = FRTriplescreenResolution<FilterResultsViewModel>()
    @Published public var potraitscreenResolution = FRPotraitscreenResolution<FilterResultsViewModel>()
    @Published public var miscResolution = FRMiscResolution<FilterResultsViewModel>()
    @Published public var source = FRSource<FilterResultsViewModel>()
    @AppStorage("FRTag") public var tag = FRTag.all
    
    public func widescreenGeneral(_ control: GeneralControl) {
        let mirror = Mirror(reflecting: self)
        for case let (label?, _) in mirror.children {
            if ["_standardDefinition", "_resolution1280x720", "_resolution1920x1080", "_resolution2560x1440", " _resolution3840x2160"].contains(label) {
                (mirror.descendant(label) as? AppStorage<Bool>)?.wrappedValue = (control == .all ? true : false)
            }
        }
    }
    
    public func reset() {
        self.showOnly = .none
        self.type = .all
        self.ageRating = .all
        self.widescreenResolution.reset()
        self.ultraWidescreenResolution.reset()
        self.triplescreenResolution.reset()
        self.potraitscreenResolution.reset()
        self.miscResolution.reset()
        self.source.reset()
        self.tag = .all
//        self.showOnly                   = .all
//        self.type                       = .all
//        self.ageRating                  = .all
//        self.widescreenResolution       = .all
//        self.ultraWidescreenResolution  = .all
//        self.triplescreenResolution     = .all
//        self.potraitscreenResolution    = .all
//        self.miscResolution             = .all
//        self.source                     = .all
//        self.tag                        = .all
    }
}

struct FilterResults: View {
    @ObservedObject var viewModel: FilterResultsViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 30) {
                    Button {
                        viewModel.reset()
                    } label: {
                        Label("Reset Filters", systemImage: "arrow.triangle.2.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    VStack(alignment: .leading) {
                        Group {
                            ForEach(Array(zip(FRShowOnly.allOptions.indices, FRShowOnly.allOptions)), id: \.0) { (i, option) in
                                let (option, image) = option
                                if i == 0 {
                                    let color = Color.green
                                } else if i == 1 {
                                    let color = Color.pink
                                } else if i == 2 {
                                    let color = Color.orange
                                } else {
                                    let color = Color.accentColor
                                }
                                
                                Toggle(isOn: Binding<Bool>(get: {
                                    viewModel.showOnly.contains(FRShowOnly(rawValue: 1 << i))
                                }, set: {
                                    if $0 {
                                        viewModel.showOnly.insert(FRShowOnly(rawValue: 1 << i))
                                    } else {
                                        viewModel.showOnly.remove(FRShowOnly(rawValue: 1 << i))
                                    }
                                    print(String(describing: viewModel.showOnly))
                                })) {
                                    HStack(spacing: 2) {
                                        Image(systemName: image)
                                            .foregroundStyle(color)
                                        Text(option)
                                    }
                                }
                            }
                        }
                        .toggleStyle(.checkbox)
                    }
                    .padding(.all)
                    .padding(.top)
                    .overlay {
                        ZStack {
                            Rectangle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color(nsColor: NSColor.unemphasizedSelectedTextBackgroundColor))
                                .padding(.top, 8)
                            VStack {
                                HStack {
                                    Text("Show Only:")
                                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                                        .padding(.leading, 5)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                    }
                    VStack(spacing: 15) {
                        FilterSection("Type", alignment: .leading) {
                            ForEach(Array(zip(FRType.allOptions.indices, FRType.allOptions)), id: \.0) { (i, option) in
                                Toggle(option, isOn: Binding<Bool>(get: {
                                    viewModel.type.contains(FRType(rawValue: 1 << i))
                                }, set: {
                                    if $0 {
                                        viewModel.type.insert(FRType(rawValue: 1 << i))
                                    } else {
                                        viewModel.type.remove(FRType(rawValue: 1 << i))
                                    }
                                    print(String(describing: viewModel.type))
                                }))
                                if i == 3 {
                                    Divider()
                                        .overlay(Color.accentColor)
                                }
                            }
                        }
                        FilterSection("Age Rating", alignment: .leading) {
                            ForEach(Array(zip(FRAgeRating.allOptions.indices, FRAgeRating.allOptions)), id: \.0) { (i, option) in
                                Toggle(option, isOn: Binding<Bool>(get: {
                                    viewModel.ageRating.contains(FRAgeRating(rawValue: 1 << i))
                                }, set: {
                                    if $0 {
                                        viewModel.ageRating.insert(FRAgeRating(rawValue: 1 << i))
                                    } else {
                                        viewModel.ageRating.remove(FRAgeRating(rawValue: 1 << i))
                                    }
                                    print(String(describing: viewModel.ageRating))
                                }))
                            }
                        }
                        FilterSection("Resolution", alignment: .leading) {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Widescreen")
                                        .bold()
                                    HStack {
                                        Button("All")  {
                                            viewModel.widescreenGeneral(.all)
                                        }
                                        Button("None") {
                                            viewModel.widescreenGeneral(.none)
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Standard Definition",   isOn: $viewModel.widescreenResolution.standardDefinition)
                                    Toggle("1280 x 720",            isOn: $viewModel.widescreenResolution.resolution1280x720)
                                    Toggle("1920 x 1080 - Full HD", isOn: $viewModel.widescreenResolution.resolution1920x1080)
                                    Toggle("2560 x 1440",           isOn: $viewModel.widescreenResolution.resolution2560x1440)
                                    Toggle("3840 x 2160 - 4K",      isOn: $viewModel.widescreenResolution.resolution3840x2160)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Ultra Widescreen")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Ultrawide Standard", isOn: $viewModel.ultraWidescreenResolution.ultrawideStandard)
                                    Toggle("2560 x 1080", isOn: $viewModel.ultraWidescreenResolution.resolution2560x1080)
                                    Toggle("3440 x 1440", isOn: $viewModel.ultraWidescreenResolution.resolution3440x1440)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Dual Monitor")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Dual Standard", isOn: $viewModel.ultraWidescreenResolution.dualStandard)
                                    Toggle("3840 x 1080", isOn: $viewModel.ultraWidescreenResolution.resolution3840x1080)
                                    Toggle("5120 x 1440", isOn: $viewModel.ultraWidescreenResolution.resolution5120x1440)
                                    Toggle("7680 x 2160", isOn: $viewModel.ultraWidescreenResolution.resolution7680x2160)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Triple Monitor")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Triple Standard", isOn: $viewModel.triplescreenResolution.tripleStandard)
                                    Toggle("4096 x 768", isOn: $viewModel.triplescreenResolution.resolution4096x768)
                                    Toggle("5760 x 1080", isOn: $viewModel.triplescreenResolution.resolution5760x1080)
                                    Toggle("7680 x 1440", isOn: $viewModel.triplescreenResolution.resolution7680x1440)
                                    Toggle("11520 x 2160", isOn: $viewModel.triplescreenResolution.resolution11520x2160)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Potrait Monitor / Phone")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Potrait Standard", isOn: $viewModel.potraitscreenResolution.potraitStandard)
                                    Toggle("720 x 1280", isOn: $viewModel.potraitscreenResolution.resolution720x1280)
                                    Toggle("1080 x 1920", isOn: $viewModel.potraitscreenResolution.resolution1080x1920)
                                    Toggle("1440 x 2560", isOn: $viewModel.potraitscreenResolution.resolution1440x2560)
                                    Toggle("2160 x 3840", isOn: $viewModel.potraitscreenResolution.resolution2160x3840)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            Group {
                                Toggle("Other Resolution",   isOn: $viewModel.miscResolution.otherResolution)
                                Toggle("Dynamic Resolution", isOn: $viewModel.miscResolution.dynamicResolution)
                            }
                            .toggleStyle(.checkbox)
                        }
                        FilterSection("Source", alignment: .leading) {
                            Group {
                                Toggle("Official", isOn: $viewModel.source.official)
                                Toggle("Workshop", isOn: $viewModel.source.workshop)
                                Toggle("My Wallpapers", isOn: $viewModel.source.myWallpapers)
                            }
                            .toggleStyle(.checkbox)
                        }
                        FilterSection("Tags", alignment: .leading) {
                            HStack {
                                Button("All")  { viewModel.tag = .all }
                                Button("None") { viewModel.tag = .none }
                            }
                            .buttonStyle(.link)
                            Group {
                                ForEach(Array(zip(FRTag.allOptions.indices, FRTag.allOptions)), id: \.0) { (i, option) in
                                    Toggle(option, isOn: Binding<Bool>(get: {
                                        viewModel.tag.contains(FRTag(rawValue: 1 << i))
                                    }, set: {
                                        if $0 {
                                            viewModel.tag.insert(FRTag(rawValue: 1 << i))
                                        } else {
                                            viewModel.tag.remove(FRTag(rawValue: 1 << i))
                                        }
                                        print(String(describing: viewModel.tag))
                                    }))
                                }
                            }
                            .toggleStyle(.checkbox)
                        }
                    }
                }
                .padding(.trailing)
            }
        }
        Divider()
    }
}
