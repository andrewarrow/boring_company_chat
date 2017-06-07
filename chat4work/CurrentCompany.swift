//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class CurrentCompany: NSView {
  
  let companyName = NSTextField(frame: NSMakeRect(0, 5, 200, 30))
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)
    translatesAutoresizingMaskIntoConstraints = true
    
    wantsLayer = true
    layer?.backgroundColor = NSColor.lightGray.cgColor
    
    companyName.stringValue = "Company Name Long"
    companyName.isEditable = false
    companyName.backgroundColor = NSColor.lightGray
    companyName.isBordered = false
    companyName.font = NSFont.boldSystemFont(ofSize: 14.0)
    addSubview(companyName)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
