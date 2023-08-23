//
//  TopTabBar.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct TopTabBar: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    
    init(contentViewModel viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Group {
                    Button { } label: {
                        Label("Installed", systemImage: "square.and.arrow.down.fill")
                            .padding(2)
                    }
                    .overlay(Rectangle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color.accentColor))
                    Button { } label: {
                        Label("Discover", systemImage: "doc.viewfinder.fill")
                            .padding(2)
                    }
                    .overlay(Rectangle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color.accentColor))
                    Button { } label: {
                        Label("Workshop", systemImage: "globe")
                            .padding(2)
                    }
                    .overlay(Rectangle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color.accentColor))
                }
                .fixedSize()
                .buttonStyle(.plain)
                Spacer()
                    .frame(minWidth: 10)
                Group {
                    Button { } label: {
                        Label("Mobile", systemImage: "platter.filled.bottom.iphone")
                    }
                    Button {
                        viewModel.isDisplaySettingsReveal = true
                    } label: {
                        Label("Displays", systemImage: "display")
                    }
                    Button{
                        AppDelegate.shared.openSettingsWindow()
                    } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
                .fixedSize()
                .buttonStyle(.plain)
            }
            .offset(x: 0.5)
            Divider()
                .frame(height: 2)
                .overlay(Color.accentColor)
        }
    }
}

@available(macOS 14, *)
#Preview {
    TopTabBar(contentViewModel: ContentViewModel())
        .padding()
        .frame(width: 800)
}
