//
//  WallpaperExplorer.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct WallpaperExplorer: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    @State var imageScaleIndex: Int = -1
    @State var selectedIndex: Int!
    
    init(contentViewModel viewModel: ContentViewModel, wallpaperViewModel: WallpaperViewModel) {
        self.viewModel = viewModel
        self.wallpaperViewModel = wallpaperViewModel
    }
    
    var body: some View {
        ScrollView {
            // MARK: Items
            if wallpaperViewModel.wallpapers.isEmpty {
                HStack {
                    Spacer()
                    Text("""
                        No wallpapers found for your search.
                        Expand or reset the categories in the filter sidebar or try another search term.
                        """)
                    .font(.title)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(10)
                    Spacer()
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 50)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))], alignment: .leading) {
                    ForEach(Array(zip(wallpaperViewModel.wallpapers, zip(viewModel.urls.indices, viewModel.urls))), id: \.1.0) { (wallpaper, legacy) in
                        let (index, url) = legacy
                        GifImage(contentsOf: { (url: URL) in
                            if let selectedProject = try? JSONDecoder()
                                .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                                return url.appending(path: selectedProject.preview)
                            }
                            return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
                        }(url))
                        .resizable()
                        .frame(maxWidth: 150, maxHeight: 150)
                        .scaleEffect(imageScaleIndex == index ? 1.2 : 1.0)
                        .clipShape(Rectangle())
                        .border(Color.accentColor, width: imageScaleIndex == index ? 1.0 : 0)
                        .selected(index == viewModel.selectedIndex)
                        .animation(.spring(), value: imageScaleIndex == index ? 1.2 : 1.0)
                        .overlay {
                            VStack {
                                Spacer()
                                ZStack {
                                    Rectangle()
                                        .frame(height: 30)
                                        .foregroundStyle(Color.black)
                                        .opacity(imageScaleIndex == index ? 0.4 : 0.2)
                                        .animation(.default, value: imageScaleIndex)
                                    Text(wallpaper.project.title)
                                        .font(.footnote)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color(white: imageScaleIndex == index ? 0.7 : 0.9))
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.default.speed(2)) {
                                viewModel.selectedIndex = index
                            }
                        }
                        .onHover { onHover in
                            if onHover {
                                print(index)
                                imageScaleIndex = index
                            }
                        }
                    }
                }
                          .padding(.trailing)
            }
//                                    if viewModel.urls.isEmpty {
//                                        VStack {
//                                            Text("Import")
//                                                .font(.title)
//                                                .lineLimit(nil)
//                                        }
//                                        .padding()
//                                        .frame(width: 200, height: 200)
//                                        .background(Color(nsColor: .controlBackgroundColor))
//                                        .onTapGesture {
//                                            AppDelegate.shared.openImportFromFolderPanel()
//                                        }
//                                        .onDrop(of: [.folder], isTargeted: $isDropTargeted) { providers in
//                                            isParseFinished = false
//                                            // 确认拖入文件数量只有一个
//                                            if providers.count != 1 { return false }
//                                            let folder = providers.first!
//                                            // 确认拖入文件为`文件夹`类型
//                                            if !folder.hasItemConformingToTypeIdentifier("public.folder") { return false }
//                                            // 解析文件夹目录位置
//                                            folder.loadItem(forTypeIdentifier: "public.folder") { item, error in
//                                                let projectUrl = (item as! URL)
//                                                self.projectUrl = projectUrl
//                                                do {
//                                                    // 根据解析出的目录下的project.json文件得到壁纸信息
//                                                    let projectData = try Data(contentsOf: projectUrl.appendingPathComponent("project.json"))
//                                                    project = try JSONDecoder().decode(WEProject.self, from: projectData)
//                                                    isParseFinished = true
//                                                } catch {
//                                                    return
//                                                }
//                                            }
//                                            return true
//                                        }
//                                    } else {
//
//                                    }
            
            //                            ForEach(viewModel.wallpapers) { wallpaper in
            //                                ZStack {
            //                                    GifImage(gifName: wallpaper.preview.filename ?? "")
            //                                            .resizable()
            //                                            .aspectRatio(contentMode: .fit)
            //                                            .scaleEffect(imageScaleIndex == index ? 1.2 : 1.0)
            //                                            .clipShape(Rectangle())
            //                                            .border(Color.accentColor, width: imageScaleIndex == index ? 1.0 : 0)
            //                                            .selected(index == viewModel.selectedIndex ?? 0)
            //                                            .animation(.spring, value: imageScaleIndex == index ? 1.2 : 1.0)
            //                                    VStack {
            //                                        Spacer()
            //                                        ZStack {
            //                                            Rectangle()
            //                                                .frame(height: 30)
            //                                                .foregroundStyle(Color.black)
            //                                                .opacity(imageScaleIndex == index ? 0.4 : 0.2)
            //                                                .animation(.default, value: imageScaleIndex)
            //                                            Text("Sumeru【Genshin Impact】")
            //                                                .font(.footnote)
            //                                                .lineLimit(2)
            //                                                .multilineTextAlignment(.center)
            //                                                .foregroundStyle(Color(white: imageScaleIndex == index ? 0.7 : 0.9))
            //                                        }
            //                                    }
            //                                }
            //                                .onTapGesture {
            //                                    withAnimation(.default.speed(2)) {
            //                                        viewModel.selectedIndex = index
            //                                    }
            //                                }
            //                                .onHover { onHover in
            //                                    if onHover {
            //                                        imageScaleIndex = index
            //                                    }
            //                                }
            //                            }
            //                        }
            //                        .padding(.trailing)
            //                        .frame(maxWidth: .infinity)
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<wallpaperViewModel.maxPage) { page in
                        Button("\(page + 1)") {
                            wallpaperViewModel.currentPage = page + 1
                        }
                    }
                }
                .padding(.bottom)
            }
        }    }
}

// MARK: - View Modifiers Extension
struct SelectedItem: ViewModifier {
    var selected: Bool
    
    init(_ selected: Bool) {
        self.selected = selected
    }
    
    func body(content: Content) -> some View {
        return content
            .border(Color.accentColor, width: selected ? 3 : 0)
    }
}

extension View {
    func selected(_ selected: Bool = true) -> some View {
        return modifier(SelectedItem(selected))
    }
}
