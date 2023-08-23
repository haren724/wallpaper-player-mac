//
//  WorkingInProgress.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/21.
//

import SwiftUI

struct WorkingInProgress: View {
    
    @State var bigGearAngle = 0.0
    @State var smallGearAngle = 0.0
    
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
