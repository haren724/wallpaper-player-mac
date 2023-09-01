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
                HStack(alignment: .bottom) {
                    Button {
                        viewModel.topTabBarSelection = 0
                    } label: {
                        Label("Installed", systemImage: "square.and.arrow.down.fill")
                            .contentShape(Rectangle())
                            .foregroundStyle(viewModel.topTabBarSelection == 0 || viewModel.topTabBarHoverSelection == 0 ? .white : .primary)
                            .font(.title2)
                            .padding(4)
                    }
                    .background(viewModel.topTabBarSelection == 0 ? Color.blue : Color.clear)
                    .background(viewModel.topTabBarHoverSelection == 0 ? Color.blue : Color.clear)
                    .overlay(Rectangle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.accentColor))
                    .onHover { hovering in
                        if hovering {
                            viewModel.topTabBarHoverSelection = 0
                        } else {
                            viewModel.topTabBarHoverSelection = -1
                        }
                    }
                    Button {
                        viewModel.topTabBarSelection = 1
                    } label: {
                        Label("Discover", systemImage: "sparkle.magnifyingglass")
                            .contentShape(Rectangle())
                            .foregroundStyle(viewModel.topTabBarSelection == 1 ? .white : .primary)
                            .foregroundStyle(viewModel.topTabBarHoverSelection == 1 ? .white : .primary)
                            .font(.title3)
                            .padding(4)
                    }
                    .background(viewModel.topTabBarSelection == 1 ? Color.blue : Color.clear)
                    .background(viewModel.topTabBarHoverSelection == 1 ? Color.blue : Color.clear)
                    .overlay(Rectangle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.accentColor))
                    .onHover { hovering in
                        if hovering {
                            viewModel.topTabBarHoverSelection = 1
                        } else {
                            viewModel.topTabBarHoverSelection = -1
                        }
                    }
                    Button {
                        viewModel.topTabBarSelection = 2
                    } label: {
                        Label("Workshop", systemImage: "cloud.fill")
                            .contentShape(Rectangle())
                            .foregroundStyle(viewModel.topTabBarSelection == 2 ? .white : .primary)
                            .foregroundStyle(viewModel.topTabBarHoverSelection == 2 ? .white : .primary)
                            .font(.title3)
                            .padding(4)
                    }
                    .background(viewModel.topTabBarSelection == 2 ? Color.blue : Color.clear)
                    .background(viewModel.topTabBarHoverSelection == 2 ? Color.blue : Color.clear)
                    .overlay(Rectangle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.accentColor))
                    .onHover { hovering in
                        if hovering {
                            viewModel.topTabBarHoverSelection = 2
                        } else {
                            viewModel.topTabBarHoverSelection = -1
                        }
                    }
                }
                .animation(.default, value: viewModel.topTabBarSelection)
                .animation(.default, value: viewModel.topTabBarHoverSelection)
                .fixedSize()
                .buttonStyle(.plain)
                Spacer()
                    .frame(minWidth: 10)
                Group {
                    Divider()
                    Button { } label: {
                        Label("Mobile", systemImage: "platter.filled.bottom.iphone")
                            .contentShape(Rectangle())
                    }
                    Divider()
                    Button {
                        viewModel.isDisplaySettingsReveal = true
                    } label: {
                        Label("Displays", systemImage: "display")
                            .contentShape(Rectangle())
                    }
                    Divider()
                    Button{
                        AppDelegate.shared.openSettingsWindow()
                    } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                            .contentShape(Rectangle())
                    }
                    Divider()
                }
                .fixedSize()
                .buttonStyle(.plain)
            }
            .offset(x: 1)
            Divider()
                .frame(height: 4)
                .overlay(Color.accentColor)
        }
    }
}
