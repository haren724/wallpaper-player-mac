//
//  ContentViewModel.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @AppStorage("FilterReveal") var isFilterReveal = false
    @AppStorage("WallpaperURLs") var wallpaperUrls = [URL]()
    @AppStorage("SelectedIndex") var selectedIndex = 0
    
    @Published var isDisplaySettingsReveal = false
    @Published var importAlertPresented = false
    @Published var isStaging = false
    
    var importAlertError: WPImportError? = nil
    
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
