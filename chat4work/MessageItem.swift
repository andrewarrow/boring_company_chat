//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class MessageItem: NSView {
  
  let msg = NSTextField(frame: NSMakeRect(5, 5, 200, 25))
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    //wantsLayer = true
    //layer?.backgroundColor = NSColor.darkGray.cgColor
    
    msg.stringValue = "Channel Name Long"
    msg.isEditable = false
    msg.backgroundColor = NSColor.white
    msg.isBordered = false
    msg.font = NSFont.systemFont(ofSize: 14.0)
    addSubview(msg)
    
  }
  
  func getStringValue() -> String {
    return msg.stringValue
  }
  
  func setStringValue(val: String) {
    msg.stringValue = val
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
