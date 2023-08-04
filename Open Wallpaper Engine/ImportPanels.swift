//
//  ImportPanels.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/4.
//

import Cocoa

struct WPImportError: LocalizedError {
    var errorDescription: String?
    var failureReason: String?
    var helpAnchor: String?
    var recoverySuggestion: String?
    
    static let permissionDenied         = WPImportError(errorDescription: "Permission Denied",
                                                failureReason: "This app doesn't have the permission to access to the folder(s) you selected",
                                                helpAnchor: "File Permission",
                                                recoverySuggestion: "Try enable it in 'System Settings' - 'Privacy & Security'")
    
    static let doesNotContainWallpaper  = WPImportError(errorDescription: "No Wallpaper(s) Inside",
                                                       failureReason: "Maybe you selected the wrong folder which doesn't contain any wallpapers",
                                                       helpAnchor: "Contents in Folder(s)",
                                                       recoverySuggestion: "Check the folder(s) you selected and try again")
    
    static let unkown                   = WPImportError(errorDescription: "Unkown Error",
                                                        failureReason: "",
                                                        helpAnchor: "",
                                                        recoverySuggestion: "")
}

extension AppDelegate {
    @objc func openImportFromFolderPanel() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.beginSheetModal(for: self.mainWindow) { response in
            if response != .OK { return }
            guard let url = panel.urls.first else { return }
            
            guard let wallpaperFolder = try? FileWrapper(url: url)
            else {
                DispatchQueue.main.async {
                    self.contentViewModel.alertImportModal(which: .permissionDenied)
                }
                return
            }
            
            guard wallpaperFolder.fileWrappers?["project.json"] != nil
            else {
                DispatchQueue.main.async {
                    self.contentViewModel.alertImportModal(which: .doesNotContainWallpaper)
                }
                return
            }
            
            try! FileManager.default.copyItem(at: url, to: FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: url.lastPathComponent))
            
            DispatchQueue.main.async {
                self.contentViewModel.wallpaperUrls.append(contentsOf: panel.urls)
            }
        }
    }
    
    @objc func openImportFromFoldersPanel() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.beginSheetModal(for: self.mainWindow) { response in
            if response != .OK { return }
            print(String(describing: panel.urls))
            
            DispatchQueue.main.async {
                self.contentViewModel.wallpaperUrls.append(contentsOf: panel.urls)
            }
        }
    }
}
