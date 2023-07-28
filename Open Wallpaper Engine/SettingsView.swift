//
//  SettingsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

enum GSPlayback: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case keepRunning, mute, pause, stop
}

enum GSAntiAliasingQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case low, medium, high, ultra
}

enum GSPostProcessingQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case low, medium, high, ultra
}

enum GSTextureResolutionQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case low, medium, high, ultra
}

struct GlobalSettings: Codable {
    var otherApplicationFocused = GSPlayback.keepRunning
    var otherApplicationMaximized = GSPlayback.keepRunning
    var otherApplicationFullscreen = GSPlayback.keepRunning
    var otherApplicationPlayingAudio = GSPlayback.keepRunning
    var displayAsleep = GSPlayback.keepRunning
    var laptopOnBattery = GSPlayback.keepRunning
    
    var antiAliasing = GSAntiAliasingQuality.medium
    var fps: Double = 30
}

class GlobalSettingsViewModel: ObservableObject {
    @Published var settings: GlobalSettings = (try? JSONDecoder()
        .decode(GlobalSettings.self,
            from: UserDefaults.standard.data(forKey: "GlobalSettings") ?? Data()))
    ?? GlobalSettings()
    
    @Published var selection = 1
    
    func save() {
        let data = try! JSONEncoder().encode(settings)
        print(String(describing: String(data: data, encoding: .utf8)))
        UserDefaults.standard.set(data, forKey: "GlobalSettings")
    }
}

extension AppDelegate {
    @objc func jumpToPerformance() {
        self.globalSettingsViewModel.selection = 0
    }
    
    @objc func jumpToGeneral() {
        self.globalSettingsViewModel.selection = 1
    }
    
    @objc func jumpToPlugins() {
        self.globalSettingsViewModel.selection = 2
    }
    
    @objc func jumpToAbout() {
        self.globalSettingsViewModel.selection = 3
    }
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: GlobalSettingsViewModel
    
    @State private var selection = 0
    
    var performance: some View {
        Form {
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
                HStack {
                    Text("Display asleep")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Keep Running").tag(0)
                        Text("Pause").tag(1)
                        Text("Stop (free memory)").tag(2)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Laptop on battery")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Keep Running").tag(0)
                        Text("Pause").tag(1)
                        Text("Stop (free memory)").tag(2)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Application Rules")
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Edit").frame(width: 100)
                    }
                    .buttonStyle(.borderedProminent)
                }
            } header: {
                Label("Playback", systemImage: "play.fill")
            }
            Section {
                HStack(spacing: 1) {
                    Button {
                        
                    } label: {
                        Text("Low").frame(maxWidth: .infinity)
                    }
                    Divider()
                    Button {
                        
                    } label: {
                        Text("Medium").frame(maxWidth: .infinity)
                    }
                    Divider()
                    Button {
                        
                    } label: {
                        Text("High").frame(maxWidth: .infinity)
                    }
                    Divider()
                    Button {
                        
                    } label: {
                        Text("Ultra").frame(maxWidth: .infinity)
                    }
                }
                .padding(6)
                .background(Color(nsColor: NSColor.unemphasizedSelectedContentBackgroundColor))
                .buttonStyle(.borderless)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                HStack {
                    Text("Anti-aliasing")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("None").tag(0)
                        Text("MSAA x2").tag(1)
                        Text("MSAA x4").tag(2)
                        Text("MSAA x8").tag(3)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Post-precessing")
                    Spacer()
                    Picker("", selection: $selection) {
                        Text("Disabled").tag(0)
                        Text("Enabled").tag(1)
                        Text("Ultra").tag(2)
                    }
                    .frame(width: 200)
                }
                Picker("Texture Resolution", selection: $selection) {
                    Text("High Quality").tag(0)
                    Text("High Performance").tag(1)
                    Text("Automatic").tag(2)
                }
                HStack {
                    Text("FPS")
                    Spacer()
                    Slider(value: $viewModel.settings.fps, in: 10...120)
                    .frame(width: 200)
                    Text(String(format: "%.00f", viewModel.settings.fps))
                        .frame(width: 25)
                }
                HStack {
                    Text("Reflections")
                    Spacer()
                    Toggle("Reflection", isOn: .constant(true))
                        .toggleStyle(.checkbox)
                        .labelsHidden()
                }
            } header: {
                Label("Quality", systemImage: "memorychip.fill")
            }
        }
        .formStyle(.grouped)
    }
    
    var general: some View {
        Form {
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
            } header: {
                Label("Automatic Startup", systemImage: "star.fill")
            }
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
            } header: {
                Label("Basic Setup", systemImage: "gearshape.fill")
            }
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
            } header: {
                Label("macOS", systemImage: "apple.logo")
            }
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
            } header: {
                Label("Appearance", systemImage: "paintpalette.fill")
            }
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
            } header: {
                Label("Audio", systemImage: "speaker.3.fill")
            }
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
            } header: {
                Label("Video", systemImage: "film")
            }
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
            } header: {
                Label("Advanced", systemImage: "wrench.and.screwdriver.fill")
            }
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
            } header: {
                Label("Developer", systemImage: "number")
            }
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
    
    var plugins: some View {
        VStack {
            Image(systemName: "wrench.and.screwdriver.fill")
            Text("Working on it")
        }
    }
    
    var body: some View {
        VStack {
            Group {
                switch viewModel.selection {
                case 0:
                    performance
                case 1:
                    general
                case 2:
                    plugins
                case 3:
                    AboutUsView()
                default:
                    fatalError()
                }
            }
            .frame(minHeight: 400, maxHeight: 800)
            
            
            HStack {
                Spacer()
                Button {
                    viewModel.save()
                    AppDelegate.shared.settingsWindow.close()
                } label: {
                    Text("OK").frame(width: 50)
                }
                .buttonStyle(.borderedProminent)
                Button {
                    AppDelegate.shared.settingsWindow.close()
                } label: {
                    Text("Cancel").frame(width: 50)
                }
            }
            .padding(20)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GlobalSettingsViewModel())
            .frame(width: 500, height: 600)
    }
}
