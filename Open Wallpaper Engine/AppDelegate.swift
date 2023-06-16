//
//  AppDelegate.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/6.
//

import Cocoa
import SwiftUI
import AVKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var mainWindow: NSWindow!
    var settingsWindow: NSWindow!
    
    var wallpaperWindow: NSWindow!
    
    static var shared = AppDelegate()
    
// MARK: - delegate methods
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建化左上角菜单栏
        setMainMenu()
        
        // 创建化右上角常驻菜单栏
        setStatusMenu()
        
        // 创建主视窗
        setMainWindow()
        
        // 创建设置视窗
        setSettingsWindow()
        
        // 创建桌面壁纸视窗
        setWallpaperWindow()
        
        // 显示桌面壁纸
        self.wallpaperWindow.center()
        self.wallpaperWindow.orderFront(nil)
        
        // 显示主视窗
        self.mainWindow.makeKeyAndOrderFront(nil)
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        self.mainWindow.makeKeyAndOrderFront(nil)
        
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

// MARK: - misc methods
    @objc func openSettingsWindow() {
        self.settingsWindow.center()
        self.settingsWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func openMainWindow() {
        self.mainWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
// MARK: - Set Main Menu
    func setMainMenu() {
        // 主菜单
        let appMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        appMenuItem.submenu = appMenu
        appMenu.items = [
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
        
        // 文件菜单
        let fileMenu = NSMenu()
        let fileMenuItem = NSMenuItem(title: "File", action: nil, keyEquivalent: "")
        fileMenuItem.submenu = fileMenu
        fileMenu.items = [
            // 在此处添加子菜单项
            .init(title: "Close Window", action: #selector(NSApplication.shared.keyWindow?.close), keyEquivalent: "w")
        ]
        
        // 主菜单栏
        let mainMenu = NSMenu()
        mainMenu.items = [
            appMenuItem,
            fileMenuItem
        ]
        
        NSApplication.shared.mainMenu = mainMenu
    }

// MARK: Set Status Menu
    func setStatusMenu() {
        let menu = NSMenu()
        menu.items = [
            .init(title: "Show Open Wallpaper Engine", action: #selector(openMainWindow), keyEquivalent: ""),
            .separator(),
            .init(title: "Change Wallpaper", action: nil, keyEquivalent: ""),
            .separator(),
            .init(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        ]
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem.menu = menu
        
        if let button = self.statusItem.button {
            button.image = NSImage(systemSymbolName: "play.desktopcomputer", accessibilityDescription: nil)
        }
    }
    
// MARK: Set Main Window
    func setMainWindow() {
        self.mainWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        self.mainWindow.isReleasedWhenClosed = false
        self.mainWindow.title = "Open Wallpaper Engine 0.1.0 - Unofficial Edition"
        self.mainWindow.titlebarAppearsTransparent = true
        self.mainWindow.center()
        self.mainWindow.setFrameAutosaveName("MainWindow")
        self.mainWindow.contentView = NSHostingView(rootView: ContentView())
    }

// MARK: Set Settings Window
    func setSettingsWindow() {
        self.settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        self.settingsWindow.isReleasedWhenClosed = false
        self.settingsWindow.contentView = NSHostingView(rootView: SettingsView())
    }
    
// MARK: Set Wallpaper Window - Most efforts
    func setWallpaperWindow() {
        self.wallpaperWindow = NSWindow()
        self.wallpaperWindow.styleMask = [.borderless, .fullSizeContentView]
        self.wallpaperWindow.setFrame(NSScreen.main!.frame, display: true)
        self.wallpaperWindow.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopWindow)) )
        self.wallpaperWindow.collectionBehavior = .stationary
        self.wallpaperWindow.isMovable = false
        self.wallpaperWindow.titlebarAppearsTransparent = true
        self.wallpaperWindow.titleVisibility = .hidden
        self.wallpaperWindow.styleMask.insert(.fullSizeContentView)
        self.wallpaperWindow.canHide = false
        self.wallpaperWindow.canBecomeVisibleWithoutLogin = true
        self.wallpaperWindow.isReleasedWhenClosed = false
        
        self.wallpaperWindow.contentViewController = WallpaperViewController()
    }
}
