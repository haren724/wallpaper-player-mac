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
    
    init(_ gifName: String) {
        self.gifName = gifName
    }
    
    init(contentsOf url: URL) {
        self.gifUrl = url
    }
    
    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView(frame: NSRect(x: 407, y: 474, width: 92, height: 74))
        imageView.canDrawSubviewsIntoLayer = true
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        
        if let gifName = self.gifName {
            if let url = Bundle.main.url(forResource: self.gifName, withExtension: "gif") {
                if let image = NSImage(contentsOf: url) {
                    let gifRep = image.representations[0] as? NSBitmapImageRep
                    gifRep?.setProperty(.loopCount, withValue: 0)
                    imageView.image = image
                }
            }
        }
        if let gifUrl = self.gifUrl {
            if let image = NSImage(contentsOf: gifUrl) {
                let gifRep = image.representations[0] as? NSBitmapImageRep
                gifRep?.setProperty(.loopCount, withValue: 0)
                imageView.image = image
            }
        }
        
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        if let gifName = self.gifName {
            if let url = Bundle.main.url(forResource: self.gifName, withExtension: "gif") {
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
    }
}
