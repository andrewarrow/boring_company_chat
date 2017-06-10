//
//  CompanyList.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class CompanyList: NSScrollView {
    
  let left = NSView(frame: NSMakeRect(0,0,70,1560+900))
  let image1 = NSImage(named: "logo1.png")
  let image2 = NSImage(named: "ibm_logo.png")
  let image3 = NSImage(named: "hp.png")
  let image4 = NSImage(named: "insta.png")
  let image5 = NSImage(named: "mena.png")

  func changeCompany(sender:NSButton) {
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "companyDidChange"),
      object: "A very different name \(sender.tag)")
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "channelDidChange"),
      object: "channel \(sender.tag)")
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    wantsLayer = true
    
    left.wantsLayer = true
    left.layer?.backgroundColor = NSColor.lightGray.cgColor
    for i in 0...0 {
      let imageView = NSButton(frame: NSMakeRect(10,(CGFloat(i*60)),50,50))
      imageView.image = image1
      imageView.tag = i
      imageView.target = self
      imageView.action = #selector(changeCompany)
      imageView.alphaValue = 1.0
      imageView.image = image5
      

      left.addSubview(imageView)
    }

    translatesAutoresizingMaskIntoConstraints = true
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewHeightSizable)
    
    left.translatesAutoresizingMaskIntoConstraints = true
    left.autoresizingMask.insert(NSAutoresizingMaskOptions.viewHeightSizable)

    documentView = left
    hasVerticalScroller = false
    //documentView?.scroll(NSPoint(x: 0, y:200))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
 
