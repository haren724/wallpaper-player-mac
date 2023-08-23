//
//  AboutUsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

extension AppDelegate {
    @objc func showAboutUs() {
        let window = NSWindow()
        window.styleMask = [.closable, .titled]
        window.isReleasedWhenClosed = false
        window.title = ""
        window.contentView = NSHostingView(rootView: AboutUsView())
        window.center()
        window.makeKeyAndOrderFront(nil)
    }
}

struct AboutUsView: View {
    var body: some View {
        VStack(spacing: 50) {
            HStack {
                Image(nsImage: NSImage(named: "AppIcon")!)
                Divider().frame(maxHeight: 100)
                VStack(alignment: .leading) {
                    Text("Open Wallpaper Engine").bold().font(.title)
                    Text("Wallpaper Engine for Mac").font(.footnote)
                }
            }
            VStack(spacing: 20) {
                Text("version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)")
                HStack {
                    Text("Made with ❤️ by")
                    Link("@haren724", destination: URL(string: "https://github.com/haren724")!)
                }
                .font(.footnote)
            }
        }
        .frame(width: 400, height: 300)
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
