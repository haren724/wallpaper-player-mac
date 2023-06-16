//
//  SettingsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var selection = 0
    
    var performance: some View {
        List {
            Section {
                HStack {
                    Text("Other Application Focused:")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Keep Running").tag(0)
                        Text("Mute").tag(1)
                        Text("Pause").tag(2)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Other Application Maximized:")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Keep Running").tag(0)
                        Text("Mute").tag(1)
                        Text("Pause").tag(2)
                        Text("Stop (free memory)").tag(3)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Other Application Fullscreen:")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Keep Running").tag(0)
                        Text("Mute").tag(1)
                        Text("Pause").tag(2)
                        Text("Stop (free memory)").tag(3)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Other Application Playing Audio:")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Keep Running").tag(0)
                        Text("Mute").tag(1)
                        Text("Pause").tag(2)
                    }
                    .frame(width: 200)
                }
                
            } header: {
                Label("Playback", systemImage: "play.fill")
            }
            Section {
                Picker("", selection: $selection) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                    Text("Ultra").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.trailing, 6)
                Text("Spacer")
                    .frame(height: 1000)
            } header: {
                Label("Quality", systemImage: "memorychip.fill")
            }
        }
        .listStyle(.sidebar)
    }
    
    var body: some View {
        TabView {
            performance.tabItem {
                Label("Performance", systemImage: "speedometer")
            }
            
            Text("Hello").tabItem {
                Label("General", systemImage: "gear")
            }
            
            Text("Hello").tabItem {
                Label("Plugins", systemImage: "powerplug.fill")
            }
            
            AboutUsView().tabItem {
                Label("About", systemImage: "person.circle.fill")
            }
        }
        .padding(20)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
