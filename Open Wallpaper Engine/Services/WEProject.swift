//
//  WEProject.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import Foundation
import ImageIO

struct WEProjectSchemeColor: Codable, Equatable {
    var order: Int
    var text: String
    var type: String
    var value: String
}

struct WEProjectProperties: Codable, Equatable {
    var schemecolor: WEProjectSchemeColor
}

struct WEProjectGeneral: Codable, Equatable {
    var properties: WEProjectProperties
}

struct WEProject: Codable, Equatable {
    var contentrating: String
    var description: String
    var file: String
    var general: WEProjectGeneral
    var preview: String
    var tags: [String]
    var title: String
    var visibility: String?
    var workshopid: String?
    var type: String?
    var version: Int?
}

struct WEWallpaper: Hashable {
    func hash(into hasher: inout Hasher) {

    }
    
    public let directory: FileWrapper
    
    public let project: WEProject
    public let preview: FileWrapper
    public let resource: FileWrapper
    
    init(wallpaperURL: URL) throws {
        guard let wallpaperDirectory = try? FileWrapper(url: wallpaperURL), wallpaperDirectory.isDirectory == true
        else { throw WEInitError.badDirectoryPath }
        
        self.directory = wallpaperDirectory
        
        guard let projectDataJSON = wallpaperDirectory.fileWrappers?["project.json"]?.regularFileContents
        else { throw WEInitError.JSONProject(was: .notFound) }
        
        guard let wallpaperProject = try? JSONDecoder().decode(WEProject.self, from: projectDataJSON)
        else { throw WEInitError.JSONProject(was: .corrupted) }
        
        self.project = wallpaperProject
        
        guard let wallpaperPreview = wallpaperDirectory.fileWrappers?["preview.gif"]
        else { throw WEInitError.preview(was: .notFound) }
        
        if let data = wallpaperPreview.regularFileContents {
            if CGImageSourceCreateWithData(NSData(data: data), nil) == nil {
                throw WEInitError.preview(was: .notImage)
            }
        } else { throw WEInitError.preview(was: .unkownError)}
        
        self.preview = wallpaperPreview
        
        guard let wallpaperResource = wallpaperDirectory.fileWrappers?[wallpaperProject.file]
        else { throw WEInitError.resources(was: .notFound) }
        
        self.resource = wallpaperResource
    }
}

enum WEInitError: Error {
    enum WEJSONProjectInitError: Error {
        case notFound, corrupted, mismatched, unkownError
    }
    
    enum WEResourcesInitError: Error {
        case notFound, mismatchedFormat, corrupted, unkownError
    }
    
    enum WEPreviewInitError: Error {
        case notFound, notImage, unkownError
    }
    
    case badDirectoryPath
    case JSONProject(was: WEJSONProjectInitError)
    case resources(was: WEResourcesInitError)
    case preview(was: WEPreviewInitError)
}
