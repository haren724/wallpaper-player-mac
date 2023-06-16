//
//  Open_Wallpaper_EngineApp.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI
import AVKit

//@main
struct Open_Wallpaper_EngineApp: App {
    @Environment(\.openWindow) private var openWindow
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    //    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup(id: "content") {
            ContentView()
        }
        
        Settings {
            SettingsView()
        }
        
        Window("", id: "about") {
            AboutUsView()
        }
        .windowStyle(.hiddenTitleBar)
        
        Window("", id: "settings") {
            SettingsView()
        }
        
        
        MenuBarExtra("App Menu Bar Extra", systemImage: "play.desktopcomputer", isInserted: $showMenuBarExtra) {
            Section {
                Button("About") { openWindow(id: "about") }
            }
            
            Section {
                Button { } label: {
                    HStack {
                        Image(systemName: "photo.fill")
                        Text("Change Wallpaper")
                    }
                }
                Button { } label: {
                    HStack {
                        Image(systemName: "network")
                        Text("Browse Workshop")
                    }
                }
                Button { } label: {
                    HStack {
                        Image(systemName: "moon.stars.fill")
                        Text("Change Screensaver")
                    }
                }
            }
            
            Section {
                Button { } label: {
                    HStack {
                        Image(systemName: "network")
                        Text("Browse Workshop")
                    }
                }
                Button { } label: {
                    HStack {
                        Image(systemName: "pencil.and.ruler.fill")
                        Text("Create Wallpaper")
                    }
                }
                Button { openWindow(id: "settings") } label: {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Preferences")
                    }
                }
            }
            
            Section {
                Button { } label: {
                    HStack {
                        Image(systemName: "questionmark")
                        Text("Support & FAQ")
                    }
                }
            }
            
            Section {
                Button { } label: {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Take Screenshot")
                    }
                }
                Button { } label: {
                    HStack {
                        Image(systemName: "speaker.slash.fill")
                        Text("Mute")
                    }
                }
                Button { } label: {
                    HStack {
                        Image(systemName: "pause")
                        Text("Pause")
                    }
                }
                Button { exit(0) } label: {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit")
                    }
                }
            }
        }
        
        
        //        WindowGroup {
        //            ExampleView()
        //                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        //        }
    }
}
