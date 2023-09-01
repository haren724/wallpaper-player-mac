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
            .init(title: "About Open Wallpaper Engine", action: #selector(self.showAboutUs), keyEquivalent: ""),
            .separator(),
            .init(title: "Settings...", action: #selector(openSettingsWindow), keyEquivalent: ","),
            .separator(),
            .init(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"),
            .separator(),
            .init(title: "Hide", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"),
            {
                let item = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
                item.keyEquivalentModifierMask = [.command, .option]
                return item
            }()
        ]
        
        // 导入子菜单
        let importMenu = NSMenuItem(title: "Import", action: nil, keyEquivalent: "")
        importMenu.submenu = NSMenu()
        importMenu.submenu?.items = [
            .init(title: "Wallpaper from Folder", action: #selector(openImportFromFolderPanel), keyEquivalent: "i"),
            .init(title: "Wallpapers in Folders", action: #selector(openImportFromFoldersPanel), keyEquivalent: "")
        ]
        
        // 文件菜单
        let fileMenu = NSMenuItem()
        fileMenu.submenu = NSMenu(title: "File")
        fileMenu.submenu?.items = [
            // 在此处添加子菜单项
            importMenu,
            .separator(),
            .init(title: "Close Window", action: #selector(AppDelegate.shared.mainWindowController.window.performClose), keyEquivalent: "w")
        ]
        
        // Edit Menu
        let editMenu = NSMenuItem()
        editMenu.submenu = NSMenu(title: "Edit")
        editMenu.submenu?.items = [
            .init(title: "Undo", action: #selector(UndoManager.undo), keyEquivalent: "z"),
            .init(title: "Redo", action: #selector(UndoManager.redo), keyEquivalent: "Z"),
            .separator(),
            .init(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"),
            .init(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"),
            .init(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"),
            .init(title: "Delete All", action: #selector(NSText.delete(_:)), keyEquivalent: String(NSBackspaceCharacter)),
            .separator(),
            .init(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        ]
        
        // 查看菜单
        let viewMenu = NSMenuItem()
        viewMenu.submenu = NSMenu(title: "View")
        viewMenu.submenu?.items = [
            {
                let item = NSMenuItem(title: "Show Filter Results", action: #selector(self.toggleFilter), keyEquivalent: "s")
                item.keyEquivalentModifierMask = [.command, .control]
                return item
            }(),
            .separator(),
            {
                let item = NSMenuItem(title: "Enter Full Screen", action: #selector(AppDelegate.shared.mainWindowController.window.toggleFullScreen(_:)), keyEquivalent: "f")
                item.keyEquivalentModifierMask = [.command, .control]
                return item
            }()
        ]
        
        // 窗口菜单
        let windowMenu = NSMenuItem()
        windowMenu.submenu = NSMenu(title: "Window")
        windowMenu.submenu?.items = [
            {
                let item = NSMenuItem(title: "Wallpaper Explorer", action: #selector(openMainWindow), keyEquivalent: "1")
                item.keyEquivalentModifierMask = [.command, .shift]
                return item
            }()
        ]
        
        // 帮助菜单
        let helpMenu = NSMenuItem()
        helpMenu.submenu = NSMenu(title: "Help")
        helpMenu.submenu?.items = [
            .init(title: "Reset First Launch", action: #selector(resetFirstLaunch), keyEquivalent: ""),
            .init(title: "Toggle Desktop Wallpaper Windowo (Debug)", action: #selector(toggleDesktopWallpaperWindow), keyEquivalent: "")
        ]
        
        // 主菜单栏
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
}

extension NSMenuItem {
    public convenience init(title: String, systemImage: String, action: Selector?, keyEquivalent: String) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent)
        self.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: nil)
        
    }
}
