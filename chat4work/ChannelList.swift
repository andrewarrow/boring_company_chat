//
//  CompanyList.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class ChannelList: NSScrollView {
    
  let list = NSView(frame: NSMakeRect(0,0,220,1560+900))
  
  func changeChannel(sender:NSButton) {
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "channelDidChange"),
      object: "channel \(sender.tag)")
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    wantsLayer = true
    
    for i in 0...0 {
      let imageView = NSButton(frame: NSMakeRect(10,(CGFloat(i*30)),200,25))
      imageView.title = "Boring Channel"
      imageView.tag = i
      imageView.target = self
      imageView.action = #selector(changeChannel)
      imageView.alphaValue = 1.0
      list.addSubview(imageView)
    }
    
    list.wantsLayer = true
    list.layer?.backgroundColor = NSColor.lightGray.cgColor

    translatesAutoresizingMaskIntoConstraints = true
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewHeightSizable)
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)

    documentView = list
    hasVerticalScroller = false
    //documentView?.scroll(NSPoint(x: 0, y:2000))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
 
