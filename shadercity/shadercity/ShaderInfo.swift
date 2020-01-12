//
//  ShaderInfo.swift
//  shadercity
//
//  Created by Alex Linkov on 1/12/20.
//  Copyright © 2020 SDWR. All rights reserved.
//
import Cocoa

class ShaderInfo {
    var url: String?
    var thumbnail: NSImage?
    
    init(with url: String, thumbURL: URL) {
        self.thumbnail = NSImage(contentsOf: thumbURL)!
        self.url = url
    }
    
}
