//
//  GeneralPage.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/12.
//

import SwiftUI

struct GeneralPage: SettingsPage {
    @ObservedObject var viewModel: GlobalSettingsViewModel
    
    init(globalSettings viewModel: GlobalSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            // MARK: Automatic Startup
            Section {
                Toggle("Start with macOS", isOn: .constant(true))
                Toggle("Protect against crashes", isOn: .constant(true))
                Toggle("Safe start after hibernation", isOn: .constant(true))
            } header: {
                Label("Automatic Startup", systemImage: "star.fill")
            }
            // MARK: Basic Setup
            Section {
                Picker("Language", selection: .constant(0)) {
                    Text("Follow System").tag(0)
                    Text("English").tag(1)
                    Text("Chinese Simplified").tag(2)
                }
            } header: {
                Label("Basic Setup", systemImage: "gearshape.fill")
            }
            // MARK: macOS
            Section {
                HStack {
                    Text("Adjust Menu Bar Color")
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Fully take over").tag(0)
                        Text("Disabled").tag(1)
                        Text("Only enabled when app is running").tag(2)
                    }
                    .frame(width: 200)
                }
            } header: {
                Label("macOS", systemImage: "apple.logo")
            }
            // MARK: Appearance
            Section {
                HStack {
                    Text("Theme")
                    Spacer()
                    Picker("", selection: .constant(0)) {
                        Text("Light").tag(0)
                        Text("Dark").tag(1)
                        Text("Auto").tag(2)
                    }
                    .frame(width: 200)
                }
            } header: {
                Label("Appearance", systemImage: "paintpalette.fill")
            }
            // MARK: Audio
            Section {
                Toggle(isOn: .constant(true)) {
                    Text("Audio Output")
                }
                Toggle(isOn: .constant(true)) {
                    Text("Reload when changing output device")
                }
            } header: {
                Label("Audio", systemImage: "speaker.3.fill")
            }
            // MARK: Video
            Section {
                Picker("Video Framework", selection: .constant(0)) {
                    Text("Apple AVKit").tag(0)
                }
            } header: {
                Label("Video", systemImage: "film")
            }
            // MARK: Advanced
            Section {
                Picker("Process Piority", selection: .constant(0)) {
                    Text("Normal").tag(0)
                    Text("Below Normal").tag(1)
                }
                Toggle("Pause when VRAM is exhausted", isOn: .constant(true))
                Toggle("Restart after crashing", isOn: .constant(true))
            } header: {
                Label("Advanced", systemImage: "wrench.and.screwdriver.fill")
            }
            // MARK: Developers
            Section {
                Picker("Log Level", selection: .constant(0)) {
                    Text("None").tag(0)
                    Text("Errors Only").tag(1)
                    Text("Verbose").tag(2)
                }
            } header: {
                Label("Developer", systemImage: "number")
            }
            // MARK: Reset
            Section {
                HStack {
                    Text("Reset Config")
                    Spacer()
                    Button {
                        viewModel.settings = GlobalSettings()
                    } label: {
                        Text("Reset").frame(width: 100)
                    }
                    .tint(Color.red)
                    .buttonStyle(.borderedProminent)
                }
            } header: {
                Label("Reset", systemImage: "exclamationmark.triangle.fill")
            }
        }.formStyle(.grouped)
    }
}
