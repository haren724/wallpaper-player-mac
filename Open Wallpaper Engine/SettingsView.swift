//
//  SettingsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

enum GSQuality: Codable {
    case low, medium, high, ultra
}

struct GlobalSettings: Codable {
    var quality = GSQuality.medium
}

class GlobalSettingsViewModel: ObservableObject {
    @Published var settings: GlobalSettings = (try? JSONDecoder()
        .decode(GlobalSettings.self,
            from: UserDefaults.standard.data(forKey: "GlobalSettings") ?? Data()))
    ?? GlobalSettings()
    
    @Published var selection = 0
    
    func save() {
        UserDefaults.standard.set(try! JSONEncoder().encode(settings),
                                  forKey: "GlobalSettings")
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
        .formStyle(.grouped)
    }
    
    var general: some View {
        Text("1")
    }
    
    var plugins: some View {
        Text("2")
    }
    
    var about: some View {
        Text("3")
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
//            .toolbar {
//                Button {
//                    
//                } label: {
//                    Label("Perdormance", systemImage: "speedometer")
//                }
//                Button {
//                    
//                } label: {
//                    Label("General", systemImage: "gearshape")
//                }
//                Button {
//                    
//                } label: {
//                    Label("Plugins", systemImage: "puzzlepiece.extension")
//                }
//                Button {
//                    
//                } label: {
//                    Label("About", systemImage: "person.3")
//                }
//            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 500, height: 600)
    }
}
