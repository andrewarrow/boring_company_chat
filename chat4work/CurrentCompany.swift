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
  
  func companyDidChange(notification: NSNotification) {
    let team = notification.object as! Team
    companyName.stringValue = team.name!
  }
  
  
  func teamLogout(notification: NSNotification) {
    
  }
  
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    NotificationCenter.default.addObserver(self,
      selector: #selector(companyDidChange),
      name: NSNotification.Name(rawValue: "companyDidChange"),
      object: nil)
    
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)
    translatesAutoresizingMaskIntoConstraints = true
    
    wantsLayer = true
    layer?.backgroundColor = NSColor.lightGray.cgColor
    
    companyName.stringValue = "Boring Company Chat"
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
