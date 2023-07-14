//
//  FilterResultsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/29.
//

import SwiftUI

class FilterResultsViewModel: ObservableObject {
    @AppStorage("Approved") var approved = true
    @AppStorage("MyFavourites") var myFavourites = true
    @AppStorage("MobileCompatible") var mobileCompatible = true
    
    func reset() {
        
    }
}

struct FilterResults: View {
    @ObservedObject var viewModel: FilterResultsViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 30) {
                    Button {
                        viewModel.showOnly.reset()
                    } label: {
                        Label("Reset Filters", systemImage: "arrow.triangle.2.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    VStack(alignment: .leading) {
//                        let mirror = Mirror(reflecting: viewModel)
//                        ForEach(Array(mirror.children), id: \.label) { child in
//                            Toggle(isOn: (mirror.descendant(child.label!) as! AppStorage<Bool>).projectedValue) {
//                                HStack(spacing: 2) {
//                                    Image(systemName: "trophy.fill")
//                                        .foregroundStyle(Color.green)
//                                    Text("Approved")
//                                }
//                            }
//                        }
                        Group {
                            Toggle(isOn: $viewModel.showOnly.approved) {
                                HStack(spacing: 2) {
                                    Image(systemName: "trophy.fill")
                                        .foregroundStyle(Color.green)
                                    Text("Approved")
                                }
                            }
                            Toggle(isOn: $viewModel.showOnly.myFavourites) {
                                HStack(spacing: 2) {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(Color.pink)
                                    Text("My Favourites")
                                }
                            }
                            Toggle(isOn: $viewModel.showOnly.mobileCompatible) {
                                HStack(spacing: 2) {
                                    Image(systemName: "iphone.gen3")
                                        .foregroundStyle(Color.orange)
                                    Text("Mobile Compatible")
                                }
                            }
                            Toggle(isOn: $viewModel.showOnly.audioResponsive) {
                                Text("Audio Responsive")
                            }
                            Toggle(isOn: $viewModel.showOnly.customizable) {
                                Text("Customizable")
                            }
                        }
                        .toggleStyle(.checkbox)
                    }
                    .padding(.all)
                    .padding(.top)
                    .overlay {
                        ZStack {
                            Rectangle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color(nsColor: NSColor.unemphasizedSelectedTextBackgroundColor))
                                .padding(.top, 8)
                            VStack {
                                HStack {
                                    Text("Show Only:")
                                        .background(Color(nsColor: NSColor.windowBackgroundColor))
                                        .padding(.leading, 5)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        
                    }
                    VStack(spacing: 15) {
                        FilterSection("Type", alignment: .leading) {
                            Toggle(isOn: $viewModel.type.scene) {
                                Text("Scene")
                            }
                            Toggle(isOn: $viewModel.type.video) {
                                Text("Video")
                            }
                            Toggle(isOn: $viewModel.type.web) {
                                Text("Web")
                            }
                            Toggle(isOn: $viewModel.type.application) {
                                Text("Application")
                            }
                            Divider()
                                .overlay(Color.accentColor)
                            Toggle(isOn: $viewModel.type.wallpaper) {
                                Text("Wallpaper")
                            }
                            Toggle(isOn: $viewModel.type.preset) {
                                Text("Preset")
                            }
                        }
                        FilterSection("Age Rating", alignment: .leading) {
                            Toggle(isOn: $viewModel.ageRating.everyone) {
                                Text("Everyone")
                            }
                            Toggle(isOn: $viewModel.ageRating.partialNudity) {
                                Text("Partial Nudity")
                            }
                            Toggle(isOn: $viewModel.ageRating.mature) {
                                Text("Mature")
                            }
                        }
                        FilterSection("Resolution", alignment: .leading) {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Widescreen")
                                        .bold()
                                    HStack {
                                        Button("All")  {
                                            viewModel.widescreenGeneral(.all)
                                        }
                                        Button("None") {
                                            viewModel.widescreenGeneral(.none)
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Standard Definition",   isOn: $viewModel.widescreenResolution.standardDefinition)
                                    Toggle("1280 x 720",            isOn: $viewModel.widescreenResolution.resolution1280x720)
                                    Toggle("1920 x 1080 - Full HD", isOn: $viewModel.widescreenResolution.resolution1920x1080)
                                    Toggle("2560 x 1440",           isOn: $viewModel.widescreenResolution.resolution2560x1440)
                                    Toggle("3840 x 2160 - 4K",      isOn: $viewModel.widescreenResolution.resolution3840x2160)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Ultra Widescreen")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Ultrawide Standard", isOn: $viewModel.ultraWidescreenResolution.ultrawideStandard)
                                    Toggle("2560 x 1080", isOn: $viewModel.ultraWidescreenResolution.resolution2560x1080)
                                    Toggle("3440 x 1440", isOn: $viewModel.ultraWidescreenResolution.resolution3440x1440)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Dual Monitor")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Dual Standard", isOn: $viewModel.ultraWidescreenResolution.dualStandard)
                                    Toggle("3840 x 1080", isOn: $viewModel.ultraWidescreenResolution.resolution3840x1080)
                                    Toggle("5120 x 1440", isOn: $viewModel.ultraWidescreenResolution.resolution5120x1440)
                                    Toggle("7680 x 2160", isOn: $viewModel.ultraWidescreenResolution.resolution7680x2160)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Triple Monitor")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Triple Standard", isOn: $viewModel.triplescreenResolution.tripleStandard)
                                    Toggle("4096 x 768", isOn: $viewModel.triplescreenResolution.resolution4096x768)
                                    Toggle("5760 x 1080", isOn: $viewModel.triplescreenResolution.resolution5760x1080)
                                    Toggle("7680 x 1440", isOn: $viewModel.triplescreenResolution.resolution7680x1440)
                                    Toggle("11520 x 2160", isOn: $viewModel.triplescreenResolution.resolution11520x2160)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Potrait Monitor / Phone")
                                        .bold()
                                    HStack {
                                        Button("All")  { }
                                        Button("None") { }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    Toggle("Potrait Standard", isOn: $viewModel.potraitscreenResolution.potraitStandard)
                                    Toggle("720 x 1280", isOn: $viewModel.potraitscreenResolution.resolution720x1280)
                                    Toggle("1080 x 1920", isOn: $viewModel.potraitscreenResolution.resolution1080x1920)
                                    Toggle("1440 x 2560", isOn: $viewModel.potraitscreenResolution.resolution1440x2560)
                                    Toggle("2160 x 3840", isOn: $viewModel.potraitscreenResolution.resolution2160x3840)
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            Group {
                                Toggle("Other Resolution",   isOn: $viewModel.miscResolution.otherResolution)
                                Toggle("Dynamic Resolution", isOn: $viewModel.miscResolution.dynamicResolution)
                            }
                            .toggleStyle(.checkbox)
                        }
                        FilterSection("Source", alignment: .leading) {
                            Group {
                                Toggle("Official", isOn: $viewModel.source.official)
                                Toggle("Workshop", isOn: $viewModel.source.workshop)
                                Toggle("My Wallpapers", isOn: $viewModel.source.myWallpapers)
                            }
                            .toggleStyle(.checkbox)
                        }
                        FilterSection("Tags", alignment: .leading) {
                            HStack {
                                Button("All")  { }
                                Button("None") { }
                            }
                            .buttonStyle(.link)
                            Group {
//                                ForEach(Array(viewModel.tags.enumerated()), id: \.1) { index, tag in
//                                    Toggle(tag, isOn: viewModel.getTag(index))
//                                }
                            }
                            .toggleStyle(.checkbox)
                        }
                    }
                }
                .padding(.trailing)
            }
        }
        Divider()
    }
}
