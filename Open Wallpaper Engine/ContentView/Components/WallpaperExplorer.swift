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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.explorerIconSize, maximum: viewModel.explorerIconSize * 2))], alignment: .leading) {
                    ForEach(Array(wallpaperViewModel.wallpapers.enumerated()), id: \.0) { (index, wallpaper) in
                        GifImage(contentsOf: { (url: URL) in
                            if let selectedProject = try? JSONDecoder()
                                .decode(WEProject.self, from: Data(contentsOf: url.appending(path: "project.json"))) {
                                return url.appending(path: selectedProject.preview)
                            }
                            return Bundle.main.url(forResource: "WallpaperNotFound", withExtension: "mp4")!
                        }(wallpaper.wallpaperDirectory))
                        .resizable()
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
                                        .padding(4)
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
                        .aspectRatio(contentMode: .fit)
                    }
                }
                          .padding(.trailing)
            }
        }
        .overlay {
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<wallpaperViewModel.maxPage, id: \.self) { page in
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
