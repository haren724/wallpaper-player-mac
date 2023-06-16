//
//  ExplorerView.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/6/6.
//

import SwiftUI

struct ExplorerView: NSViewRepresentable {
//    @EnvironmentObject var appDelegate: Open_wallpaper_EngineAppDelegate
    
    func makeNSView(context: Context) -> some NSView {
        let splitView = NSSplitView()
        
        splitView.isVertical = true
        splitView.addArrangedSubview(NSHostingView(rootView: Text("Hello")))
        splitView.addArrangedSubview(NSHostingView(rootView: VStack {
            Color.red
        }))
        splitView.dividerStyle = .thin
        
        return splitView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

struct ExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorerView()
    }
}
