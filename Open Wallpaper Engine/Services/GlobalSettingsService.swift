//
//  GlobalSettingsService.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/9/2.
//

import Cocoa

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
