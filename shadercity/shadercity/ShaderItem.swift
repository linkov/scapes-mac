//
//  ShaderItem.swift
//  shadercity
//
//  Created by Alex Linkov on 1/12/20.
//  Copyright © 2020 SDWR. All rights reserved.
//

import Cocoa

class ShaderItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.wantsLayer = true
        view.layer?.cornerRadius = 8.0
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
     
            if isSelected {
                view.layer?.backgroundColor = NSColor.selectedControlColor.cgColor
            } else {
                view.layer?.backgroundColor = NSColor.clear.cgColor
            }
        }
    }
    
}
