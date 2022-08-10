//
//  Images.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 10/08/22.
//

import AppKit

extension NSImage {
    
    @available(macOS 11.0, *)
    static let settingsIcon: NSImage = NSImage.init(systemSymbolName: "gear", accessibilityDescription: nil)!
    
    @available(macOS 11.0, *)
    static let quitIcon: NSImage = NSImage.init(systemSymbolName: "xmark", accessibilityDescription: nil)!
}
