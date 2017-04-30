//
//  WindowController.swift
//  Elemental
//
//  Created by MIles Work on 2017/04/30.
//  Copyright © 2017 StudioRepublika. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

  
    @IBOutlet var addressEntry: NSTextField!
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.titleVisibility = .hidden
    }

}
