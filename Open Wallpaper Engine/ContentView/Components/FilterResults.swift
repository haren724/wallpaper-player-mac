//
//  FilterResults.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/29.
//

import SwiftUI

struct FilterSection<Content>: View where Content: View {
    private let content: Content
    private let alignment: HorizontalAlignment
    private var spacing: CGFloat?
    private let titleKey: LocalizedStringKey
    
    @State private var isExpanded: Bool = true
    
    init(_ titleKey: LocalizedStringKey, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.alignment = alignment
        self.spacing = spacing
        self.titleKey = titleKey
    }
    
    var body: some View {
        VStack(alignment: self.alignment, spacing: self.spacing) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .rotationEffect(isExpanded ? .zero : .degrees(-90.0))
                        .animation(.spring(), value: isExpanded)
                    Text(self.titleKey)
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            if isExpanded {
                content.padding(.leading, (self.alignment == .leading) ? 10 : 0)
            }
        }
    }
}

struct FilterResults: View {
    @ObservedObject var viewModel: FilterResultsViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 30) {
                    Button {
                        viewModel.reset()
                    } label: {
                        Label("Reset Filters", systemImage: "arrow.triangle.2.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    VStack(alignment: .leading) {
                        Group {
                            ForEach(Array(zip(FRShowOnly.allOptions.indices, FRShowOnly.allOptions)), id: \.0) { (i, option) in
                                let (option, image) = option
                                let color: Color = {
                                    if i == 0 {
                                        return Color.green
                                    } else if i == 1 {
                                        return Color.pink
                                    } else if i == 2 {
                                        return Color.orange
                                    } else {
                                        return Color.accentColor
                                    }
                                }()
                                Toggle(isOn: Binding<Bool>(get: {
                                    viewModel.showOnly.contains(FRShowOnly(rawValue: 1 << i))
                                }, set: {
                                    if $0 {
                                        viewModel.showOnly.insert(FRShowOnly(rawValue: 1 << i))
                                    } else {
                                        viewModel.showOnly.remove(FRShowOnly(rawValue: 1 << i))
                                    }
                                    print(String(describing: viewModel.showOnly))
                                })) {
                                    HStack(spacing: 2) {
                                        Image(systemName: image)
                                            .foregroundStyle(color)
                                        Text(option)
                                    }
                                }
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
                            ForEach(Array(zip(FRType.allOptions.indices, FRType.allOptions)), id: \.0) { (i, option) in
                                Toggle(option, isOn: Binding<Bool>(get: {
                                    viewModel.type.contains(FRType(rawValue: 1 << i))
                                }, set: {
                                    if $0 {
                                        viewModel.type.insert(FRType(rawValue: 1 << i))
                                    } else {
                                        viewModel.type.remove(FRType(rawValue: 1 << i))
                                    }
                                    print(String(describing: viewModel.type))
                                }))
                                if i == 3 {
                                    Divider()
                                        .overlay(Color.accentColor)
                                }
                            }
                        }
                        FilterSection("Age Rating", alignment: .leading) {
                            ForEach(Array(zip(FRAgeRating.allOptions.indices, FRAgeRating.allOptions)), id: \.0) { (i, option) in
                                Toggle(option, isOn: Binding<Bool>(get: {
                                    viewModel.ageRating.contains(FRAgeRating(rawValue: 1 << i))
                                }, set: {
                                    if $0 {
                                        viewModel.ageRating.insert(FRAgeRating(rawValue: 1 << i))
                                    } else {
                                        viewModel.ageRating.remove(FRAgeRating(rawValue: 1 << i))
                                    }
                                    print(String(describing: viewModel.ageRating))
                                }))
                            }
                        }
                        FilterSection("Resolution", alignment: .leading) {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Widescreen")
                                        .bold()
                                    HStack {
                                        Button("All")  {
                                            viewModel.widescreenResolution = .all
                                        }
                                        Button("None") {
                                            viewModel.widescreenResolution = .none
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    ForEach(Array(zip(FRWidescreenResolution.allOptions.indices, FRWidescreenResolution.allOptions)), id: \.0) { (i, option) in
                                        Toggle(option, isOn: Binding<Bool>(get: {
                                            viewModel.widescreenResolution.contains(FRWidescreenResolution(rawValue: 1 << i))
                                        }, set: {
                                            if $0 {
                                                viewModel.widescreenResolution.insert(FRWidescreenResolution(rawValue: 1 << i))
                                            } else {
                                                viewModel.widescreenResolution.remove(FRWidescreenResolution(rawValue: 1 << i))
                                            }
                                            print(String(describing: viewModel.widescreenResolution))
                                        }))
                                    }
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
                                        Button("All")  {
                                            viewModel.ultraWidescreenResolution = .all
                                        }
                                        Button("None") {
                                            viewModel.ultraWidescreenResolution = .none
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    ForEach(Array(zip(FRUltraWidescreenResolution.allOptions.indices, FRUltraWidescreenResolution.allOptions)), id: \.0) { (i, option) in
                                        Toggle(option, isOn: Binding<Bool>(get: {
                                            viewModel.ultraWidescreenResolution.contains(FRUltraWidescreenResolution(rawValue: 1 << i))
                                        }, set: {
                                            if $0 {
                                                viewModel.ultraWidescreenResolution.insert(FRUltraWidescreenResolution(rawValue: 1 << i))
                                            } else {
                                                viewModel.ultraWidescreenResolution.remove(FRUltraWidescreenResolution(rawValue: 1 << i))
                                            }
                                            print(String(describing: viewModel.ultraWidescreenResolution))
                                        }))
                                    }
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            VStack(alignment: .leading) {
                                // MARK: - have trouble
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Dual Monitor")
                                        .bold()
                                    HStack {
                                        Button("All")  { 
                                            viewModel.dualscreenResolution = .all
                                        }
                                        Button("None") {
                                            viewModel.dualscreenResolution = .none
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    ForEach(Array(zip(FRDualscreenResolution.allOptions.indices, FRDualscreenResolution.allOptions)), id: \.0) { (i, option) in
                                        Toggle(option, isOn: Binding<Bool>(get: {
                                            viewModel.dualscreenResolution.contains(FRDualscreenResolution(rawValue: 1 << i))
                                        }, set: {
                                            if $0 {
                                                viewModel.dualscreenResolution.insert(FRDualscreenResolution(rawValue: 1 << i))
                                            } else {
                                                viewModel.dualscreenResolution.remove(FRDualscreenResolution(rawValue: 1 << i))
                                            }
                                            print(String(describing: viewModel.dualscreenResolution))
                                        }))
                                    }
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
                                        Button("All")  { 
                                            viewModel.triplescreenResolution = .all
                                        }
                                        Button("None") {
                                            viewModel.triplescreenResolution = .none
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    ForEach(Array(zip(FRTriplescreenResolution.allOptions.indices, FRTriplescreenResolution.allOptions)), id: \.0) { (i, option) in
                                        Toggle(option, isOn: Binding<Bool>(get: {
                                            viewModel.triplescreenResolution.contains(FRTriplescreenResolution(rawValue: 1 << i))
                                        }, set: {
                                            if $0 {
                                                viewModel.triplescreenResolution.insert(FRTriplescreenResolution(rawValue: 1 << i))
                                            } else {
                                                viewModel.triplescreenResolution.remove(FRTriplescreenResolution(rawValue: 1 << i))
                                            }
                                            print(String(describing: viewModel.triplescreenResolution))
                                        }))
                                    }
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
                                        Button("All")  {
                                            viewModel.potraitscreenResolution = .all
                                        }
                                        Button("None") { 
                                            viewModel.potraitscreenResolution = .none
                                        }
                                    }
                                    .buttonStyle(.link)
                                }
                                .padding(.top, 5)
                                Group {
                                    ForEach(Array(zip(FRPortraitScreenResolution.allOptions.indices, FRPortraitScreenResolution.allOptions)), id: \.0) { (i, option) in
                                        Toggle(option, isOn: Binding<Bool>(get: {
                                            viewModel.potraitscreenResolution.contains(FRPortraitScreenResolution(rawValue: 1 << i))
                                        }, set: {
                                            if $0 {
                                                viewModel.potraitscreenResolution.insert(FRPortraitScreenResolution(rawValue: 1 << i))
                                            } else {
                                                viewModel.potraitscreenResolution.remove(FRPortraitScreenResolution(rawValue: 1 << i))
                                            }
                                            print(String(describing: viewModel.potraitscreenResolution))
                                        }))
                                    }
                                }
                                .toggleStyle(.checkbox)
                                Divider()
                                    .overlay(Color.accentColor)
                            }
                            Group {
                                ForEach(Array(zip(FRMiscResolution.allOptions.indices, FRMiscResolution.allOptions)), id: \.0) { (i, option) in
                                    Toggle(option, isOn: Binding<Bool>(get: {
                                        viewModel.miscResolution.contains(FRMiscResolution(rawValue: 1 << i))
                                    }, set: {
                                        if $0 {
                                            viewModel.miscResolution.insert(FRMiscResolution(rawValue: 1 << i))
                                        } else {
                                            viewModel.miscResolution.remove(FRMiscResolution(rawValue: 1 << i))
                                        }
                                        print(String(describing: viewModel.miscResolution))
                                    }))
                                }
                            }
                            .toggleStyle(.checkbox)
                        }
                        FilterSection("Source", alignment: .leading) {
                            Group {
                                ForEach(Array(zip(FRSource.allOptions.indices, FRSource.allOptions)), id: \.0) { (i, option) in
                                    Toggle(option, isOn: Binding<Bool>(get: {
                                        viewModel.source.contains(FRSource(rawValue: 1 << i))
                                    }, set: {
                                        if $0 {
                                            viewModel.source.insert(FRSource(rawValue: 1 << i))
                                        } else {
                                            viewModel.source.remove(FRSource(rawValue: 1 << i))
                                        }
                                        print(String(describing: viewModel.source))
                                    }))
                                }
                            }
                            .toggleStyle(.checkbox)
                        }
                        FilterSection("Tags", alignment: .leading) {
                            HStack {
                                Button("All")  {
                                    viewModel.tag = .all
                                }
                                Button("None") { 
                                    viewModel.tag = .none
                                }
                            }
                            .buttonStyle(.link)
                            Group {
                                ForEach(Array(zip(FRTag.allOptions.indices, FRTag.allOptions)), id: \.0) { (i, option) in
                                    Toggle(option, isOn: Binding<Bool>(get: {
                                        viewModel.tag.contains(FRTag(rawValue: 1 << i))
                                    }, set: {
                                        if $0 {
                                            viewModel.tag.insert(FRTag(rawValue: 1 << i))
                                        } else {
                                            viewModel.tag.remove(FRTag(rawValue: 1 << i))
                                        }
                                        print(String(describing: viewModel.tag))
                                    }))
                                }
                            }
                            .toggleStyle(.checkbox)
                        }
                    }
                }
                .padding(.trailing)
            }
            .lineLimit(1)
        }
        Divider()
    }
}
