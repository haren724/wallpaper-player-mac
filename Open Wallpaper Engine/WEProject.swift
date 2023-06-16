//
//  WEProject.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import Foundation

struct WEProjectSchemeColor: Codable {
    var order: Int
    var text: String
    var type: String
    var value: String
}

struct WEProjectProperties: Codable {
    var schemecolor: WEProjectSchemeColor
}

struct WEProjectGeneral: Codable {
    var properties: WEProjectProperties
}

struct WEProject: Codable {
    var contentrating: String
    var description: String
    var file: String
    var general: WEProjectGeneral
    var preview: String
    var tags: [String]
    var title: String
    var visibility: String
    var workshopid: String
}
