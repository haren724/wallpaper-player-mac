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
            .init(title: "Close Window", action: #selector(AppDelegate.shared.mainWindowController.close), keyEquivalent: "w")
        ]
        
        // 查看菜单
        let viewMenu = NSMenuItem()
        viewMenu.submenu = NSMenu(title: "View")
        viewMenu.submenu?.items = [
            {
                let item = NSMenuItem(title: "Show Filter Results", action: #selector(self.toggleFilter), keyEquivalent: "s")
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
            .init(title: "Reset First Launch", action: #selector(resetFirstLaunch), keyEquivalent: "")
        ]
        
        // 主菜单栏
        let mainMenu = NSMenu()
        mainMenu.items = [
            appMenu,
            fileMenu,
            viewMenu,
            windowMenu,
            helpMenu
        ]
        
        NSApplication.shared.mainMenu = mainMenu
    }
}

extension NSMenuItem {
    public convenience init(title: String, systemImage: String, action: Selector?, keyEquivalent: String) {
        self.init(title: title, action: action, keyEquivalent: keyEquivalent)
        self.image = NSImage(systemSymbolName: systemImage, accessibilityDescription: nil)
        
    }
}
