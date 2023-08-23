//
//  GifImage.swift
//  Open Wallpaper Engine
//
//  Created by Haren on 2023/8/15.
//

import Cocoa
import SwiftUI

struct GifImage: NSViewRepresentable {
    
    var gifName: String?
    var gifUrl: URL?
    
    var isResizable: Bool = false
    var contentMode: ContentMode = .fill
    
    init(_ gifName: String) {
        self.gifName = gifName
    }
    
    init(contentsOf url: URL) {
        self.gifUrl = url
    }
    
    func makeNSView(context: Context) -> NSImageView {
        let nsView = NSImageView()
        
        nsView.canDrawSubviewsIntoLayer = true
        nsView.imageScaling = .scaleProportionallyUpOrDown
        nsView.animates = true
        
        if let gifName = self.gifName {
            if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
                if let image = NSImage(contentsOf: url) {
                    let gifRep = image.representations[0] as? NSBitmapImageRep
                    gifRep?.setProperty(.loopCount, withValue: 0)
                    nsView.image = image
                }
            }
        }
        if let gifUrl = self.gifUrl {
            if let image = NSImage(contentsOf: gifUrl) {
                let gifRep = image.representations[0] as? NSBitmapImageRep
                gifRep?.setProperty(.loopCount, withValue: 0)
                nsView.image = image
            }
        }
        
        return nsView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        updateModifiers(nsView)
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSImageView, context: Context) -> CGSize? {
        if !self.isResizable {
            return nsView.sizeThatFits(nsView.frame.size)
        } else {
            guard let width = proposal.width, let height = proposal.height else { return nil }
            return CGSize(width: width, height: height)
        }
    }
    
    private func updateModifiers(_ nsView: NSImageView) {
        if let gifName = self.gifName {
            if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
                if let image = NSImage(contentsOf: url) {
                    let gifRep = image.representations[0] as? NSBitmapImageRep
                    gifRep?.setProperty(.loopCount, withValue: 0)
                    nsView.image = image
                }
            }
        }
        if let gifUrl = self.gifUrl {
            if let image = NSImage(contentsOf: gifUrl) {
                let gifRep = image.representations[0] as? NSBitmapImageRep
                gifRep?.setProperty(.loopCount, withValue: 0)
                nsView.image = image
            }
        }
        if self.isResizable {
            switch self.contentMode {
            case .fill:
                nsView.imageScaling = .scaleAxesIndependently
            case .fit:
                nsView.imageScaling = .scaleProportionallyUpOrDown
            }
        }
    }
    
    func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Self {
        var view = self
        view.isResizable = true
        return view
    }
    
    func aspectRatio(_ aspectRatio: CGFloat? = nil, contentMode: ContentMode) -> Self {
        var view = self
        view.contentMode = contentMode
        return view
    }
}
