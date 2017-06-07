//
//  CompanyList.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class MessageList: NSScrollView {
    
  let list = NSView(frame: NSMakeRect(0,0,220,1560+900))
  
  func channelDidChange(notification: NSNotification) {
    let name = notification.object as! String
    list.subviews = []
    makeMessages(name: name)
  }
  
  func makeMessages(name:String) {
    for i in 0...81 {
      let imageView = NSTextField(frame: NSMakeRect(10,(CGFloat(i*30)),200,25))
      imageView.stringValue = "\(name) test \(i)"
      imageView.isBordered = false
      imageView.isEditable = false
      imageView.font = NSFont.systemFont(ofSize: 14.0)
      list.addSubview(imageView)
    }
  }
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    NotificationCenter.default.addObserver(self,
      selector: #selector(channelDidChange),
      name: NSNotification.Name(rawValue: "channelDidChange"),
      object: nil)
    
    wantsLayer = true
    
    makeMessages(name: "initial")
    
    list.wantsLayer = true
    list.layer?.backgroundColor = NSColor.white.cgColor

    translatesAutoresizingMaskIntoConstraints = true
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewHeightSizable)
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)

    documentView = list
    hasVerticalScroller = true
    documentView?.scroll(NSPoint(x: 0, y:2000))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
 
