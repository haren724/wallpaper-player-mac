//
//  WallpaperPreview.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct WallpaperPreview: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var wallpaperViewModel: WallpaperViewModel
    
    init(contentViewModel viewModel: ContentViewModel, wallpaperViewModel: WallpaperViewModel) {
        self.viewModel = viewModel
        self.wallpaperViewModel = wallpaperViewModel
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        GifImage(contentsOf: viewModel.selectedURLofGIF)
                        Text(viewModel.selectedCurrentTitle)
                            .lineLimit(1)
                    }
                    HStack {
                        Image("we.logo")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("< Pending >")
                    }
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }
                        .font(.caption)
                        Button { } label: {
                            Image(systemName: "heart")
                        }
                    }
                    HStack {
                        Text("Video")
                        Text("40 MB")
                    }
                    .font(.footnote)
                    HStack(spacing: 3) {
                        Text("Fantasy")
                            .padding(5)
                            .background(Color(nsColor: NSColor.controlColor))
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        Text("3840 x 2160")
                            .padding(5)
                            .background(Color(nsColor: NSColor.controlColor))
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        Text("Everyone")
                            .padding(5)
                            .background(Color(nsColor: NSColor.controlColor))
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    VStack(spacing: 3) {
                        Button { } label: {
                            Label("Unsubscribe", systemImage: "xmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        HStack(spacing: 3) {
                            Button { } label: {
                                Label("Comment", systemImage: "text.badge.star")
                                    .frame(maxWidth: .infinity)
                            }
                            Button { } label: {
                                Image(systemName: "doc.on.doc.fill")
                            }
                            Button { } label: {
                                Image(systemName: "exclamationmark.triangle.fill")
                            }
                        }
                    }
                    // MARK: Properties
                    HStack(spacing: 3) {
                        Text("Properties")
                        VStack {
                            Divider()
                                .frame(height: 1)
                                .overlay(Color.accentColor)
                        }
                    }
                    VStack(spacing: 16) {
                        ColorPicker(selection: .constant(.red), supportsOpacity: true) {
                            HStack {
                                Label("Scheme Color", systemImage: "paintpalette.fill")
                                Spacer()
                            }
                        }
                        HStack {
                            Label("Volume", systemImage: "speaker.wave.3.fill")
                            Spacer()
                            Slider(value: $wallpaperViewModel.playVolume, in: 0...1).frame(width: 100)
                            Text(String(format: "%.01f", wallpaperViewModel.playVolume))
                                .frame(width: 25)
                        }
                        HStack {
                            Label("Playback Rate", systemImage: "play.fill")
                            Spacer()
                            Slider(value: $wallpaperViewModel.playRate, in: 0...2).frame(width: 100)
                            Text(String(format: "%.01f", wallpaperViewModel.playRate))
                                .frame(width: 25)
                        }
                    }
                    VStack(spacing: 3) {
                        HStack(spacing: 3) {
                            Text("Your Presets")
                            VStack {
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color.accentColor)
                            }
                        }
                        HStack(spacing: 3) {
                            Button { } label: {
                                Label("Load", systemImage: "folder.fill")
                                    .frame(maxWidth: .infinity)
                                
                            }
                            Button { } label: {
                                Label("Save", systemImage: "square.and.arrow.down.fill")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        Button { } label: {
                            Label("Apply to all Wallpapers", systemImage: "list.bullet.rectangle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        Button { } label: {
                            Label("Share JSON", systemImage: "arrow.2.squarepath")
                                .frame(maxWidth: .infinity)
                        }
                        Button { } label: {
                            Label("Reset", systemImage: "arrow.triangle.2.circlepath")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                .padding([.horizontal, .top])
            }

            HStack {
                Spacer()
                Button {
//                        self.mainWindowController.window.performClose(nil)
                } label: {
                    Text("OK").frame(width: 50)
                }
                .buttonStyle(.borderedProminent)
                Button { } label: {
                    Text("Cancel").frame(width: 50)
                }
            }
            .padding()
        }
    }
}
