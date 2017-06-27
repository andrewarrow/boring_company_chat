//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import RealmSwift

class CurrentChannel: NSView {
  
  let channelName = NSTextField(frame: NSMakeRect(60, 5, 200, 30))
  let muteButton = NSButton(frame: NSMakeRect(5,10,50,25))
  var channel: ChannelObject?
  
  func channelDidChange(notification: NSNotification) {
    let b = notification.object as! ButtonWithStringTag
    channelName.stringValue = b.title
    channel = b.channel
    
    if channel!.mute == 1 {
      muteButton.title = "Show"
    } else {
      muteButton.title = "Mute"
    }
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
    
    muteButton.title = "Mute"
    muteButton.action = #selector(muteToggle)
    muteButton.target = self
    addSubview(muteButton)
    
  }
  
  func muteToggle() {
    if channel == nil {
      return
    }
    let realm = try! Realm()
    if muteButton.title == "Mute" {
      muteButton.title = "Show"
      try! realm.write {
        channel!.mute = 0
      }
      
    } else {
      muteButton.title = "Mute"
      try! realm.write {
        channel!.mute = 1
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
