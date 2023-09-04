//
//  DisplaySettingsView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import SwiftUI

struct DisplaySettings: SubviewOfContentView {
    @ObservedObject var viewModel: ContentViewModel
    
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.isDisplaySettingsReveal = false
            } label: {
                Image(systemName: "chevron.up")
                    .font(.largeTitle)
                    .bold()
            }
            .buttonStyle(.link)
            
            Text("Choose Display")
                .font(.largeTitle)
            
            Group {
                VStack(spacing: 5) {
                    Picker(selection: .constant(0)) {
                        Text("Wallpaper Per Display").tag(0)
                        Text("").tag(1)
                    } label: { }
                    HStack(spacing: 5) {
                        Button {
                            
                        } label: {
                            Label("Split", systemImage: "scissors")
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            
                        } label: {
                            Label("Group", systemImage: "square.on.square.squareshape.controlhandles")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    HStack(spacing: 5) {
                        Button {
                            
                        } label: {
                            Label("Load Profile", systemImage: "doc.text.fill")
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            
                        } label: {
                            Label("Save Profile", systemImage: "")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                Image("sumeru")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .overlay {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("2048x2048 MacBook Pro 14''")
                                    .font(.footnote)
                                    .foregroundStyle(Color.white)
                                    .background(Color.secondary)
                                Spacer()
                                Image(systemName: "speaker.wave.3.fill")
                                    .padding(5)
                                    .background(Color.secondary)
                            }
                            Spacer()
                        }
                        .padding(3)
                        .border(Color.accentColor, width: 3)
                    }
                HStack {
                    Button("Change Wallpaper") { }
                        .buttonStyle(.borderedProminent)
                    Button("Remove Wallpaper") { }
                }
                Spacer()
            }
            .disabled(true)
            .blur(radius: 8.0)
        }
        .overlay {
            WorkingInProgress()
        }
    }
}
