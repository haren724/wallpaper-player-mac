//
//  AboutUsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        VStack(spacing: 50) {
            HStack {
                Image("we.logo")
                Divider().frame(maxHeight: 80)
                VStack(alignment: .leading) {
                    Text("Open Wallpaper Engine").bold().font(.title)
                    Text("Wallpaper Engine for Mac").font(.footnote)
                }
            }
            VStack(spacing: 20) {
                Text("version: v0.1")
                Text("Made with ❤️ by @haren724").font(.footnote)
            }
        }
        .padding()
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
