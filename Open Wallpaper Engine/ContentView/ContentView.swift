//
//  ContentView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/5.
//

import SwiftUI

protocol SubviewOfContentView: View {
    var viewModel: ContentViewModel { get set }
    
//    init(contentViewModel viewModel: ContentViewModel)
}

struct ContentView: View {
    @EnvironmentObject var globalSettingsViewModel: GlobalSettingsViewModel
    
    @ObservedObject var viewModel: ContentViewModel
    
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    @State var isDropTargeted = false
    @State var isParseFinished = false
    @State var isFilterReveal = true
    
    @State var isDockIconHidden = false
    
    @State var project: WEProject!
    @State var projectUrl: URL!
    @State var greet: String = "Hello, world!"
    
    var body: some View {
        ZStack {
            HSplitView {
                if viewModel.isStaging {
                    VStack(spacing: 5) {
                        TopTabBar(contentViewModel: viewModel)
                        switch viewModel.topTabBarSelection {
                        case 0:
                            ExplorerTopBar(contentViewModel: viewModel)
                                .environmentObject(globalSettingsViewModel)
                            HStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    // MARK: Filter Results
                                    FilterResults(viewModel: viewModel)
                                }
                                .frame(width: viewModel.isFilterReveal ? 225 : 0)
                                .opacity(viewModel.isFilterReveal ? 1 : 0)
                                .animation(.spring(), value: viewModel.isFilterReveal)
                                
                                WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                                .onDrop(of: [.fileURL], delegate: viewModel)
                                .contextMenu {
                                    ExplorerGlobalMenu(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                                }
                                .padding(.leading, viewModel.isFilterReveal ? 10 : 0)
                            }
                            .animation(.default, value: viewModel.isFilterReveal)
                        case 1:
                            WallpaperDiscover()
                        case 2:
                            ExplorerTopBar(contentViewModel: viewModel)
                            WorkingInProgress()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        default:
                            fatalError()
                        }
                        ExplorerBottomBar()
                    }
                    .padding()
                    WallpaperPreview(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                        .frame(maxWidth: 320)
                }
            }
            .opacity(viewModel.isStaging ? 1 : 0)
            .blur(radius: viewModel.isStaging ? 0 : 2.0)
            
            // indicate that this view is initializing
            if !viewModel.isStaging {
                HStack(spacing: 20) {
                    Text("Power Saving Mode, Sleeping...")
                        .font(.largeTitle)
                }
            }
        }
        .confirmationDialog("Unsubscribe Confirmation",
                            isPresented: $viewModel.isUnsubscribeConfirming) {
            if let url = viewModel.hoveredWallpaper?.wallpaperDirectory {
                Button("Delete Immediately", role: .destructive) {
                    try? FileManager.default.removeItem(at: url)
                    if url == wallpaperViewModel.currentWallpaper.wallpaperDirectory {
                        wallpaperViewModel.currentWallpaper = WEWallpaper(using: .invalid, where: Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!)
                    }
                }
                Button("Move to Trash") {
                    try? FileManager.default.trashItem(at: url, resultingItemURL: nil)
                    if url == wallpaperViewModel.currentWallpaper.wallpaperDirectory {
                        wallpaperViewModel.currentWallpaper = WEWallpaper(using: .invalid, where: Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!)
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("\(viewModel.hoveredWallpaper?.project.title ?? "invalid wallpaper")")
        }
        .alert(isPresented: $viewModel.importAlertPresented, error: viewModel.importAlertError) {
            
        }
        .sheet(isPresented: $globalSettingsViewModel.isFirstLaunch) {
            FirstLaunchView()
                .environmentObject(globalSettingsViewModel)
        }
        .sheet(isPresented: $viewModel.isDisplaySettingsReveal) {
            DisplaySettings(viewModel: viewModel)
                .padding()
                .frame(width: 520, height: 450)
        }
        .sheet(isPresented: $viewModel.isUnsafeWallpaperWarningPresented) {
            UnsafeWallpaper(wallpaper: wallpaperViewModel.nextCurrentWallpaper)
                .frame(width: 600, height: 300)
        }
        .frame(minWidth: 1000, minHeight: 640, idealHeight: 800)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(isStaging: true), wallpaperViewModel: .init())
            .environmentObject(GlobalSettingsViewModel())
    }
}
