//
//  PluginsPage.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/12.
//

import SwiftUI

struct PluginsPage: SettingsPage {
    @ObservedObject var viewModel: GlobalSettingsViewModel
    
    @State var bigGearAngle = 0.0
    @State var smallGearAngle = 0.0
    
    init(globalSettings viewModel: GlobalSettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "gearshape")
                    .font(.system(size: 48))
                    .rotationEffect(.degrees(bigGearAngle + 30))
                    .offset(x: -20, y: -10)
                Image(systemName: "gearshape")
                    .font(.system(size: 32, weight: .semibold))
                    .rotationEffect(.degrees(smallGearAngle))
                    .offset(x: 20, y: 10)
            }
            .padding()
            .onAppear {
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                    bigGearAngle = 360
                    smallGearAngle = -360
                }
            }
            Text("Working on it")
        }
    }
}
