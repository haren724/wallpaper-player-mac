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
                        ExplorerTopBar(contentViewModel: viewModel)
                        HStack(spacing: 0) {
                            HStack(spacing: 0) {
                                // MARK: Filter Results
                                FilterResults(viewModel: self.wallpaperViewModel)
                            }
                            .frame(width: viewModel.isFilterReveal ? 225 : 0)
                            .opacity(viewModel.isFilterReveal ? 1 : 0)
                            .animation(.spring(), value: viewModel.isFilterReveal)
                            WallpaperExplorer(contentViewModel: viewModel, wallpaperViewModel: wallpaperViewModel)
                            .contextMenu {
                                ExplorerGlobalMenu(wallpaperViewModel: wallpaperViewModel)
                            }
                            .padding(.leading, viewModel.isFilterReveal ? 10 : 0)
                        }
                        .animation(.default, value: viewModel.isFilterReveal)
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
                    ProgressView()
                    Text("Loading...")
                        .font(.largeTitle)
                }
            }
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
        .frame(minWidth: 1000, minHeight: 400, idealHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(isStaging: true), wallpaperViewModel: .init())
            .environmentObject(GlobalSettingsViewModel())
    }
}
