//
//  GlobalSettingsService.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/9/2.
//

import Cocoa
import SwiftUI

enum GSQuality {
    case low, medium, high, ultra
}

enum GSPlayback: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case keepRunning, mute, pause, stop
}

enum GSAntiAliasingQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case none, msaa_x2, msaa_x4, msaa_x8
}

enum GSPostProcessingQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case disabled, enabled, ultra
}

enum GSTextureResolutionQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case highQuality, highPerformance, automatic
}

enum GSAppearance: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case light, dark, followSystem
}

struct GlobalSettings: Codable, Equatable {
    var otherApplicationFocused = GSPlayback.keepRunning
    var otherApplicationFullscreen = GSPlayback.keepRunning
    var otherApplicationPlayingAudio = GSPlayback.keepRunning
    var displayAsleep = GSPlayback.keepRunning
    var laptopOnBattery = GSPlayback.keepRunning
    
    var antiAliasing = GSAntiAliasingQuality.msaa_x2
    var postProcessing = GSPostProcessingQuality.disabled
    var textureResolution = GSTextureResolutionQuality.automatic
    var reflections = false
    var fps: Double = 30
    
    var autoRefresh = true
    
    var appearance = GSAppearance.followSystem
}

class GlobalSettingsViewModel: ObservableObject {
    @Published var settings: GlobalSettings {
        didSet {
            // Save to UserDefault
            save()
            
            switch settings.appearance {
            case .light:
                NSApplication.shared.appearance = NSAppearance(named: .aqua)
            case .dark:
                NSApplication.shared.appearance = NSAppearance(named: .darkAqua)
            case .followSystem:
                break
            }
        }
    }
    
    @Published var selection = 0
    
    @Published var isFirstLaunch = UserDefaults.standard.value(forKey: "IsFirstLaunch") as? Bool ?? true
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "GlobalSettings"),
           let settings = try? JSONDecoder().decode(GlobalSettings.self, from: data) {
            self.settings = settings
        } else {
            self.settings = GlobalSettings()
        }
    }
    
    func reset() {
        settings = (try? JSONDecoder()
            .decode(GlobalSettings.self,
                from: UserDefaults.standard.data(forKey: "GlobalSettings")
            ?? Data()))
        ?? GlobalSettings()
    }
    
    func save() {
        let data = try! JSONEncoder().encode(settings)
        print(String(describing: String(data: data, encoding: .utf8)))
        UserDefaults.standard.set(data, forKey: "GlobalSettings")
    }
    
    func setQuality(_ quality: GSQuality) {
        switch quality {
        case .low:
            self.settings.antiAliasing = .none
            self.settings.postProcessing = .disabled
            self.settings.textureResolution = .highQuality
            self.settings.fps = 10
            self.settings.reflections = false
        case .medium:
            self.settings.antiAliasing = .none
            self.settings.postProcessing = .enabled
            self.settings.textureResolution = .highQuality
            self.settings.fps = 15
            self.settings.reflections = true
        case .high:
            self.settings.antiAliasing = .msaa_x2
            self.settings.postProcessing = .enabled
            self.settings.textureResolution = .highQuality
            self.settings.fps = 25
            self.settings.reflections = true
        case .ultra:
            self.settings.antiAliasing = .msaa_x2
            self.settings.postProcessing = .ultra
            self.settings.textureResolution = .highQuality
            self.settings.fps = 30
            self.settings.reflections = true
        }
    }
}


extension AppDelegate {
    @objc func activateApplicationDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frontmostApplication = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
        
        switch frontmostApplication.bundleIdentifier {
        case "com.apple.finder":
            fallthrough
        case "\(Bundle.main.bundleIdentifier!)":
            globalSettingsWhenApplicationDidBecomeActive()
        default:
            switch self.globalSettingsViewModel.settings.otherApplicationFocused {
            case .mute:
                mute()
            case .pause:
                pause()
            case .keepRunning:
                fallthrough
            default:
                return
            }
        }
    }
    
    func globalSettingsWhenApplicationDidBecomeActive() {
        switch self.globalSettingsViewModel.settings.otherApplicationFocused {
        case .mute:
            unmute()
        case .pause:
            resume()
        case .keepRunning:
            fallthrough
        default:
            return
        }
    }
}
