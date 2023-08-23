//
//  WallpaperDiscover.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/21.
//

import SwiftUI

struct WallpaperDiscover: View {
    var body: some View {
        ScrollView {
            WorkingInProgress()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 50)
        }
    }
}

struct WallpaperDiscover_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(isStaging: true, topTabBarSelection: 1), wallpaperViewModel: .init())
            .environmentObject(GlobalSettingsViewModel())
    }
}
