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

enum GSLocalization: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case en_US, zh_CN, followSystem
}

enum GSVideoFramework: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case avkit
}

enum GSProcessPiority: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case normal, belowNormal
}

enum GSLogLevel: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case error, verbose, none
}

struct GlobalSettings: Codable, Equatable {
    
    // MARK: Playback
    var otherApplicationFocused = GSPlayback.keepRunning
    var otherApplicationFullscreen = GSPlayback.keepRunning
    var otherApplicationPlayingAudio = GSPlayback.keepRunning
    var displayAsleep = GSPlayback.keepRunning
    var laptopOnBattery = GSPlayback.keepRunning
    
    // MARK: Quality
    var antiAliasing = GSAntiAliasingQuality.msaa_x2
    var postProcessing = GSPostProcessingQuality.disabled
    var textureResolution = GSTextureResolutionQuality.automatic
    var reflections = false
    var fps: Double = 30
    
    // MARK: Automatic Setup
    var safeMode = false
    
    // MARK: Basic Setup
    var language = GSLocalization.followSystem
    
    // MARK: macOS
    var adjustMenuBarTint = true
    
    // MARK: Appearance
    var appearance = GSAppearance.followSystem
    
    // MARK: Audio
    var audioOutput = true
    var reloadWhenChangingOutputDevice = true // Not putting in use
    
    // MARK: Video
    var videoFramework = GSVideoFramework.avkit
    
    // MARK: Advanced
    var processPiority = GSProcessPiority.normal // Not putting in use
    var pauseOnVRAMExhausted = false // Not putting in use
    var restartAfterCrashing = false // Not putting in use
    
    // MARK: Developer
    var logLevel = GSLogLevel.none
    
    // MARK: Misc
    var autoRefresh = true
}

class GlobalSettingsViewModel: ObservableObject {
    @Published var settings: GlobalSettings {
        didSet { saveAndValidate() }
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
        
        // Add observers
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(validate),
                                               name: NSApplication.didFinishLaunchingNotification,
                                               object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(activateApplicationDidChange(_:)),
                                                          name: NSWorkspace.didActivateApplicationNotification,
                                                          object: nil)
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
    
    @objc private func validate() {
        switch settings.appearance {
        case .light:
            NSApplication.shared.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApplication.shared.appearance = NSAppearance(named: .darkAqua)
        case .followSystem:
            break
        }
    }
    
    @objc func activateApplicationDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frontmostApplication = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
        
        switch frontmostApplication.bundleIdentifier {
        case "com.apple.finder":
            fallthrough
        case "\(Bundle.main.bundleIdentifier!)":
            globalSettingsWhenApplicationDidBecomeActive()
        default:
            switch self.settings.otherApplicationFocused {
            case .mute:
                AppDelegate.shared.mute()
            case .pause:
                AppDelegate.shared.pause()
            case .keepRunning:
                fallthrough
            default:
                return
            }
        }
    }
    
    func globalSettingsWhenApplicationDidBecomeActive() {
        switch self.settings.otherApplicationFocused {
        case .mute:
            AppDelegate.shared.unmute()
        case .pause:
            AppDelegate.shared.resume()
        case .keepRunning:
            fallthrough
        default:
            return
        }
    }
    
    private func saveAndValidate() {
        save()
        validate()
    }
}
