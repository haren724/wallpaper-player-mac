//
//  MainWindowController.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/8.
//

import Cocoa
import SwiftUI

class MainWindowController: NSWindowController, NSWindowDelegate {
    override var window: NSWindow! {
        get {
            return super.window
        }
        set {
            super.window = newValue
        }
    }
    
    override init(window: NSWindow?) {
        super.init(window: NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false))
        self.window.delegate = self
        self.window.isReleasedWhenClosed = false
        self.window.title = "Open Wallpaper Engine 0.1.0 - Unofficial Edition"
        self.window.titlebarAppearsTransparent = true
        self.window.setFrameAutosaveName("MainWindow")
        self.window.contentView = NSHostingView(rootView: ContentView(viewModel: AppDelegate.shared.contentViewModel)
            .environmentObject(AppDelegate.shared.globalSettingsViewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowWillClose(_ notification: Notification) {
        self.window.contentView = nil
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        if self.window.contentView == nil {
            DispatchQueue.main.async {
                self.window.contentView = NSHostingView(rootView: ContentView(viewModel: AppDelegate.shared.contentViewModel)
                    .environmentObject(AppDelegate.shared.globalSettingsViewModel))
            }
        }
    }
}
