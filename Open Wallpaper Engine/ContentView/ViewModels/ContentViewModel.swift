//
//  ContentViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI
import UniformTypeIdentifiers

class ContentViewModel: ObservableObject, DropDelegate {
    @AppStorage("FilterReveal") var isFilterReveal = false
    @AppStorage("WallpaperURLs") var wallpaperUrls = [URL]()
    @AppStorage("SelectedIndex") var selectedIndex = 0
    
    @AppStorage("ExplorerIconSize") var explorerIconSize: Double = 200
    
    @Published var isDisplaySettingsReveal = false
    @Published var importAlertPresented = false
    @Published var isStaging = false
    
    @Published var topTabBarSelection: Int = 0
    @Published var topTabBarHoverSelection: Int = -1
    
    var importAlertError: WPImportError? = nil
    
    convenience init(isStaging: Bool, topTabBarSelection: Int = 0) {
        self.init()
        self.isStaging = isStaging
        self.topTabBarSelection = topTabBarSelection
    }
    
    var urls: [URL] {
        get {
            if let urls = try? FileManager.default.contentsOfDirectory(
                at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]) {
                var filteredURLs = [URL]()
                for url in urls {
                    if let files = try! FileWrapper(url: url).fileWrappers, files.contains(where: { (key, _) in
                        if key == "project.json" {
                            return true
                        } else {
                            return false
                        }
                    }) {
                        filteredURLs.append(url)
                    }
                }
                return filteredURLs
            } else {
                return []
            }
        }
        set {
            
        }
    }
    
    var selectedURL: URL {
        get {
            if self.selectedIndex < self.urls.count {
                if let selectedProject = try? JSONDecoder().decode(WEProject.self, from: Data(contentsOf: urls[self.selectedIndex].appending(path: "project.json"))) {
                    return urls[self.selectedIndex].appending(path: selectedProject.file)
                }
            }
            return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
        }
        set {
            
        }
    }
    
    var selectedURLofGIF: URL {
        if self.selectedIndex < self.urls.count {
            if let selectedProject = try? JSONDecoder().decode(WEProject.self, from: Data(contentsOf: urls[self.selectedIndex].appending(path: "project.json"))) {
                return urls[self.selectedIndex].appending(path: selectedProject.preview)
            }
        }
        return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
    }
    
    func selectedTitle(_ url: URL) -> String {
        if let selectedProject = try? JSONDecoder().decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
            return selectedProject.title
        }
        return "???"
    }
    
    var selectedCurrentTitle: String {
        if self.selectedIndex < self.urls.count {
            if let selectedProject = try? JSONDecoder().decode(WEProject.self, from: Data(contentsOf: urls[self.selectedIndex].appending(path: "project.json"))) {
                return selectedProject.title
            }
        }
        return "???"
    }
    
    func toggleFilter() {
        isFilterReveal.toggle()
    }
    
    func alertImportModal(which error: WPImportError) {
        self.importAlertError = error
        self.importAlertPresented = true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        let proposal = DropProposal(operation: .copy)
        return proposal
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [UTType.fileURL]).first
        else {
            alertImportModal(which: .unkown)
            return false
        }
        itemProvider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { [weak self] item, _ in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil)
            else {
                self?.alertImportModal(which: .unkown)
                return
            }
            // Do something with the file url
            // remember to dispatch on main in case of a @State change
            guard let wallpaperFolder = try? FileWrapper(url: url)
            else{
                self?.alertImportModal(which: .unkown)
                return
            }
            guard wallpaperFolder.fileWrappers?["project.json"] != nil
            else{
                self?.alertImportModal(which: .doesNotContainWallpaper)
                return
            }
            DispatchQueue.main.async {
                try? FileManager.default.copyItem(
                    at: url,
                    to: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        .appending(path: url.lastPathComponent)
                )
            }
        }
        return true
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
