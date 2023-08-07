//
//  FirstLaunchView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/4.
//

import SwiftUI

struct FirstLaunchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var globalSettingsViewModel: GlobalSettingsViewModel
    
    @State var checked = false
    
    var body: some View {
        VStack {
            VStack(spacing: 5) {
                Text("What's New in Open Wallpaper Engine")
                    .font(.largeTitle)
                Divider()
            }
            .fixedSize()
            VStack {
                Group {
                    NewSection(title: "Import Wallpapers from Steam Workshop",
                               text: "You can easily import video type wallpapers from steam workshop of Wallpaper Engine and modify some properties as well, like playback rate, volume, etc.",
                               systemImage: "square.and.arrow.down")
                    NewSection(title: "Similar UI Layout to Wallpaper Engine on Steam",
                               text: "You may feel familar when using this dynamic desktop wallpaper tool since it almost has the same layout to its ancesstor.",
                               systemImage: "macwindow.on.rectangle",
                               imageColor: .yellow)
                    NewSection(title: "Super High Performance",
                               text: "We brings you a smoother app animation experience. Powered by the lightweight, modern SwiftUI Framework.",
                               systemImage: "speedometer",
                               imageColor: .red)
                    NewSection(title: "We Take Care of Your Laptop's Battery Life",
                               text: "When it comes to without pluging to the power adapter, we reduced the power consumption as much as possible, without just stoping the playback.",
                               systemImage: "battery.75",
                               imageColor: .green)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
                .padding(.horizontal, 50)
            }
            Button {
                UserDefaults.standard.set(!checked, forKey: "IsFirstLaunch")
                dismiss()
            } label: {
                Text("OK")
                    .frame(width: 100)
            }
            .buttonStyle(.borderedProminent)
            HStack {
                Toggle("Never show this again until next update", isOn: $checked)
                Spacer()
            }
        }
        .textSelection(.enabled)
        .padding()
        .frame(width: 600)
    }
}

extension FirstLaunchView {
    struct NewSection: View {
        var title: LocalizedStringKey
        var text: LocalizedStringKey
        var textColor: Color = .primary
        var systemImage: String
        var imageColor: Color = .accentColor
        
        var body: some View {
            HStack {
                Image(systemName: systemImage)
                    .frame(width: 50, height: 50)
                    .font(.largeTitle)
                    .foregroundStyle(imageColor)
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(textColor)
                        .font(.title2)
                        .bold()
                    Text(text)
                        .foregroundStyle(textColor)
                }
                .multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

extension AppDelegate {
    @objc func resetFirstLaunch() {
        UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
    }
}

struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView()
    }
}
