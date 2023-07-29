//
//  SettingsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

enum GSQuality {
    case low, medium, high, ultra
}

enum GSPlayback: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case keepRunning, mute, pause, stop
}

enum GSAntiAliasingQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case none, msaa_x2, msaa_x4, msaa_x8
}

enum GSPostProcessingQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case disabled, enabled, ultra
}

enum GSTextureResolutionQuality: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    case highQuality, highPerformance, automatic
}

struct GlobalSettings: Codable {
    var otherApplicationFocused = GSPlayback.keepRunning
    var otherApplicationMaximized = GSPlayback.keepRunning
    var otherApplicationFullscreen = GSPlayback.keepRunning
    var otherApplicationPlayingAudio = GSPlayback.keepRunning
    var displayAsleep = GSPlayback.keepRunning
    var laptopOnBattery = GSPlayback.keepRunning
    
    var antiAliasing = GSAntiAliasingQuality.msaa_x2
    var postProcessing = GSPostProcessingQuality.disabled
    var textureResolution = GSTextureResolutionQuality.automatic
    var reflections = false
    var fps: Double = 30
}

class GlobalSettingsViewModel: ObservableObject {
    @Published var settings: GlobalSettings = (try? JSONDecoder()
        .decode(GlobalSettings.self,
            from: UserDefaults.standard.data(forKey: "GlobalSettings")
        ?? Data()))
    ?? GlobalSettings()
    
    @Published var selection = 0
    
    func save() {
        let data = try! JSONEncoder().encode(settings)
        print(String(describing: String(data: data, encoding: .utf8)))
        UserDefaults.standard.set(data, forKey: "GlobalSettings")
    }
    
    func setQuality(_ quality: GSQuality) {
        switch quality {
        case .low:
            self.settings.antiAliasing = .none
            self.settings.postProcessing = .disabled
            self.settings.textureResolution = .highQuality
            self.settings.fps = 10
            self.settings.reflections = false
        case .medium:
            self.settings.antiAliasing = .none
            self.settings.postProcessing = .enabled
            self.settings.textureResolution = .highQuality
            self.settings.fps = 15
            self.settings.reflections = true
        case .high:
            self.settings.antiAliasing = .msaa_x2
            self.settings.postProcessing = .enabled
            self.settings.textureResolution = .highQuality
            self.settings.fps = 25
            self.settings.reflections = true
        case .ultra:
            self.settings.antiAliasing = .msaa_x2
            self.settings.postProcessing = .ultra
            self.settings.textureResolution = .highQuality
            self.settings.fps = 30
            self.settings.reflections = true
        }
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
    @State private var isEditingFPS = false
    
    var performance: some View {
        Form {
            Section {
                HStack {
                    Text("Other Application Focused:")
                    Spacer()
                    Picker("", selection: $viewModel.settings.otherApplicationFocused) {
                        Text("Keep Running").tag(GSPlayback.keepRunning)
                        Text("Mute").tag(GSPlayback.mute)
                        Text("Pause").tag(GSPlayback.pause)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Other Application Maximized:")
                    Spacer()
                    Picker("", selection: $viewModel.settings.otherApplicationMaximized) {
                        Text("Keep Running").tag(GSPlayback.keepRunning)
                        Text("Mute").tag(GSPlayback.mute)
                        Text("Pause").tag(GSPlayback.pause)
                        Text("Stop (free memory)").tag(GSPlayback.stop)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Other Application Fullscreen:")
                    Spacer()
                    Picker("", selection: $viewModel.settings.otherApplicationFullscreen) {
                        Text("Keep Running").tag(GSPlayback.keepRunning)
                        Text("Mute").tag(GSPlayback.mute)
                        Text("Pause").tag(GSPlayback.pause)
                        Text("Stop (free memory)").tag(GSPlayback.stop)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Other Application Playing Audio:")
                    Spacer()
                    Picker("", selection: $viewModel.settings.otherApplicationPlayingAudio) {
                        Text("Keep Running").tag(GSPlayback.keepRunning)
                        Text("Mute").tag(GSPlayback.mute)
                        Text("Pause").tag(GSPlayback.pause)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Display asleep")
                    Spacer()
                    Picker("", selection: $viewModel.settings.displayAsleep) {
                        Text("Keep Running").tag(GSPlayback.keepRunning)
                        Text("Pause").tag(GSPlayback.pause)
                        Text("Stop (free memory)").tag(GSPlayback.stop)
                    }
                    .frame(width: 200)
                }
                HStack {
                    Text("Laptop on battery")
                    Spacer()
                    Picker("", selection: $viewModel.settings.laptopOnBattery) {
                        Text("Keep Running").tag(GSPlayback.keepRunning)
                        Text("Pause").tag(GSPlayback.pause)
                        Text("Stop (free memory)").tag(GSPlayback.stop)
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
                        viewModel.setQuality(.low)
                    } label: {
                        Text("Low").frame(maxWidth: .infinity)
                    }
                    Divider()
                    Button {
                        viewModel.setQuality(.medium)
                    } label: {
                        Text("Medium").frame(maxWidth: .infinity)
                    }
                    Divider()
                    Button {
                        viewModel.setQuality(.high)
                    } label: {
                        Text("High").frame(maxWidth: .infinity)
                    }
                    Divider()
                    Button {
                        viewModel.setQuality(.ultra)
                    } label: {
                        Text("Ultra").frame(maxWidth: .infinity)
                    }
                }
                .padding(6)
                .background(Color(nsColor: NSColor.unemphasizedSelectedContentBackgroundColor))
                .buttonStyle(.borderless)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                Picker("Anti-aliasing", selection: $viewModel.settings.antiAliasing) {
                    Text("None").tag(GSAntiAliasingQuality.none)
                    Text("MSAA x2").tag(GSAntiAliasingQuality.msaa_x2)
                    Text("MSAA x4").tag(GSAntiAliasingQuality.msaa_x4)
                    Text("MSAA x8").tag(GSAntiAliasingQuality.msaa_x8)
                }
                .overlay {
                    HStack {
                        Spacer(); Spacer()
                        if viewModel.settings.antiAliasing == .msaa_x8 {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                                .help("×8 MSAA is only recommended for powerful high-end desktop graphics cards.")
                        }
                        Spacer()
                    }
                    
                }
                Picker("Post-Processing", selection: $viewModel.settings.postProcessing) {
                    Text("Disabled").tag(GSPostProcessingQuality.disabled)
                    Text("Enabled").tag(GSPostProcessingQuality.enabled)
                    Text("Ultra").tag(GSPostProcessingQuality.ultra)
                }
                .overlay {
                    HStack {
                        Spacer(); Spacer()
                        if viewModel.settings.postProcessing == .ultra {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                                .help("Ultra mode adds HDR bloom to supported wallpapers and is only recommended for powerful high-end desktop graphics cards.")
                        }
                        Spacer()
                    }
                    
                }
                Picker("Texture Resolution", selection: $viewModel.settings.textureResolution) {
                    Text("High Quality").tag(GSTextureResolutionQuality.highQuality)
                    Text("High Performance").tag(GSTextureResolutionQuality.highPerformance)
                    Text("Automatic").tag(GSTextureResolutionQuality.automatic)
                }
                HStack {
                    Text("FPS")
                    Spacer()
                    Slider(value: $viewModel.settings.fps, in: 10...120)
                        .frame(width: 150)
                    if isEditingFPS {
                        TextField("FPS", text: Binding<String>(get: {
                            String(format: "%.00f", viewModel.settings.fps)
                        }, set: {
                            if let newValue = Double($0) {
                                if newValue > 120 {
                                    viewModel.settings.fps = 120
                                } else if newValue < 10 {
                                    viewModel.settings.fps = 10
                                } else {
                                    viewModel.settings.fps = newValue
                                }
                            }
                        }))
                        .textFieldStyle(.roundedBorder)
                        .labelsHidden()
                        .frame(width: 50, height: 20)
                        .onSubmit {
                            isEditingFPS = false
                        }
                    } else {
                        Text(String(format: "%.00f", viewModel.settings.fps))
                            .frame(width: 25)
                            .onTapGesture(count: 2) {
                                isEditingFPS = true
                            }
                    }
                }
                .overlay {
                    HStack {
                        Spacer(); Spacer()
                        if !isEditingFPS {
                            if viewModel.settings.fps > 60 {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.red)
                                    .help("High FPS may slow down your PC! We're serious, this is too much 🔥.")
                            } else if viewModel.settings.fps > 30 {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.yellow)
                                    .help("High FPS may slow down your PC!")
                            }
                        }
                        Spacer()
                    }
                    
                }
                HStack {
                    Text("Reflections")
                    Spacer()
                    Toggle("Reflection", isOn: $viewModel.settings.reflections)
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
        .frame(minWidth: 500)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GlobalSettingsViewModel())
            .frame(width: 500, height: 600)
    }
}
