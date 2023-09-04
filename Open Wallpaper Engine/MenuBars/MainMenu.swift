//
//  Menu.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa

extension AppDelegate {
    func setMainMenu() {
        // 主菜单
        let appMenu = NSMenuItem()
        appMenu.submenu = NSMenu(title: "Open Wallpaper Engine")
        appMenu.submenu?.items = [
            // 在此处添加子菜单项
            .init(title: String(localized: "About Open Wallpaper Engine"), action: #selector(self.showAboutUs), keyEquivalent: ""),
            .separator(),
            .init(title: String(localized: "Settings..."), action: #selector(openSettingsWindow), keyEquivalent: ","),
            .separator(),
            .init(title: String(localized: "Quit"), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"),
            .separator(),
            .init(title: String(localized: "Hide"), action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"),
            {
                let item = NSMenuItem(title: String(localized: "Hide Others"), action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
                item.keyEquivalentModifierMask = [.command, .option]
                return item
            }()
        ]
        
        // 导入子菜单
        let importMenu = NSMenuItem(title: String(localized: "Import"), action: nil, keyEquivalent: "")
        importMenu.submenu = NSMenu()
        importMenu.submenu?.items = [
            .init(title: String(localized: "Wallpaper from Folder"), action: #selector(openImportFromFolderPanel), keyEquivalent: "i"),
            .init(title: String(localized: "Wallpapers in Folders"), action: nil, keyEquivalent: "")
        ]
        
        // 文件菜单
        let fileMenu = NSMenuItem()
        fileMenu.submenu = NSMenu(title: String(localized: "File"))
        fileMenu.submenu?.items = [
            // 在此处添加子菜单项
            importMenu,
            .separator(),
            .init(title: String(localized: "Close Window"), action: #selector(AppDelegate.shared.mainWindowController.window.performClose), keyEquivalent: "w")
        ]
        
        // Edit Menu
        let editMenu = NSMenuItem()
        editMenu.submenu = NSMenu(title: String(localized: "Edit"))
        editMenu.submenu?.items = [
            .init(title: String(localized: "Undo"), action: #selector(UndoManager.undo), keyEquivalent: "z"),
            .init(title: String(localized: "Redo"), action: #selector(UndoManager.redo), keyEquivalent: "Z"),
            .separator(),
            .init(title: String(localized: "Cut"), action: #selector(NSText.cut(_:)), keyEquivalent: "x"),
            .init(title: String(localized: "Copy"), action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
            .init(title: String(localized: "Paste"), action: #selector(NSText.paste(_:)), keyEquivalent: "v"),
            .init(title: String(localized: "Delete All"), action: #selector(NSText.delete(_:)), keyEquivalent: String(NSBackspaceCharacter)),
            .separator(),
            .init(title: String(localized: "Select All"), action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        ]
        
        // 查看菜单
        let viewMenu = NSMenuItem()
        viewMenu.submenu = NSMenu(title: String(localized: "View"))
        viewMenu.submenu?.items = [
            {
                let item = NSMenuItem(title: String(localized: "Show Filter Results"), action: #selector(self.toggleFilter), keyEquivalent: "s")
                item.keyEquivalentModifierMask = [.command, .control]
                return item
            }(),
            .separator(),
            {
                let item = NSMenuItem(title: String(localized: "Enter Full Screen"), action: #selector(AppDelegate.shared.mainWindowController.window.toggleFullScreen(_:)), keyEquivalent: "f")
                item.keyEquivalentModifierMask = [.command, .control]
                return item
            }()
        ]
        
        // 窗口菜单
        let windowMenu = NSMenuItem()
        windowMenu.submenu = NSMenu(title: String(localized: "Window"))
        windowMenu.submenu?.items = [
            {
                let item = NSMenuItem(title: String(localized: "Wallpaper Explorer"), action: #selector(openMainWindow), keyEquivalent: "1")
                item.keyEquivalentModifierMask = [.command, .shift]
                return item
            }()
        ]
        
        // Debug Submenu -> Help Menu
        let debugMenu = NSMenuItem(title: String(localized: "Debug"), action: nil, keyEquivalent: "")
        debugMenu.submenu = NSMenu()
        debugMenu.submenu?.items = [
            .init(title: String(localized: "Reset First Launch"), action: #selector(resetFirstLaunch), keyEquivalent: ""),
            .init(title: String(localized: "Toggle Desktop Wallpaper Window (Debug)"), action: #selector(toggleDesktopWallpaperWindow), keyEquivalent: ""),
            .init(title: String(localized: "Reset All Trusted Wallpapers"), action: #selector(resetTrustedWallpapers), keyEquivalent: "")
        ]
        
        // Help Menu
        let helpMenu = NSMenuItem()
        helpMenu.submenu = NSMenu(title: String(localized: "Help"))
        helpMenu.submenu?.items = [
            debugMenu
        ]
        
        // Main Menu
        let mainMenu = NSMenu()
        mainMenu.items = [
            appMenu,
            fileMenu,
            editMenu,
            viewMenu,
            windowMenu,
            helpMenu
        ]
        
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func toggleDesktopWallpaperWindow() {
        if wallpaperWindow.isVisible {
            wallpaperWindow.orderOut(nil)
        } else {
            wallpaperWindow.orderFront(nil)
        }
    }
    
    @objc func resetTrustedWallpapers() {
        UserDefaults.standard.set([String](), forKey: "TrustedWallpapers")
    }
}

extension NSMenuItem {
    public convenience init(title: String, systemImage: String, action: Selector?, keyEquivalent: String) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent)
        self.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: nil)
        
    }
}
