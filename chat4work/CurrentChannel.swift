//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class CurrentChannel: NSView {
  
  let channelName = NSTextField(frame: NSMakeRect(5, 5, 200, 30))
  
  func channelDidChange(notification: NSNotification) {
    channelName.stringValue = notification.object as! String
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    NotificationCenter.default.addObserver(self,
      selector: #selector(channelDidChange),
      name: NSNotification.Name(rawValue: "channelDidChange"),
      object: nil)
    
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)
    translatesAutoresizingMaskIntoConstraints = true
    
    wantsLayer = true
    layer?.backgroundColor = NSColor.darkGray.cgColor
    
    channelName.stringValue = "Boring Channel"
    channelName.isEditable = false
    channelName.backgroundColor = NSColor.darkGray
    channelName.isBordered = false
    channelName.font = NSFont.boldSystemFont(ofSize: 14.0)
    addSubview(channelName)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
