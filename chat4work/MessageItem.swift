//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Moya
import RxSwift

class MessageItem: NSView {
  
  let user = NSTextField(frame: NSMakeRect(5, 70, 200, 25))
  let time = NSTextField(frame: NSMakeRect(150, 70, 200, 25))
  let msg = NSTextField(frame: NSMakeRect(5, 10, 680, 60))
  var sel1 = 0
  var sel2 = 0
  
  var disposeBag = DisposeBag()
  
  
  @IBAction func copy(_ sender:NSObject) {
    let pasteboard = NSPasteboard.general()
    pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
    pasteboard.setString(msg.stringValue, forType: NSPasteboardTypeString)
  }
  
  override func mouseDown(with event: NSEvent) {
    NSApplication.shared().keyWindow!.makeFirstResponder(self)
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "turnAllOff"),
      object: nil)
    
    msg.backgroundColor = NSColor.darkGray
    sel1 = 1
  }
  
  func turnOff() {
    sel1 = 0
    msg.backgroundColor = NSColor.white
  }

  override func mouseDragged(with event: NSEvent) {
    //Swift.print("Wefwef")
  }

  override func mouseUp(with event: NSEvent) {
    Swift.print("Wefwef")
  }

  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    //wantsLayer = true
    //layer?.backgroundColor = NSColor.yellow.cgColor
    
    msg.stringValue = ""
    msg.isEditable = false
    msg.backgroundColor = NSColor.white
    msg.isBordered = false
    msg.font = NSFont.systemFont(ofSize: 14.0)
    addSubview(msg)

    user.stringValue = "andrew"
    user.isEditable = false
    user.backgroundColor = NSColor.white
    user.textColor = NSColor.darkGray
    user.isBordered = false
    user.font = NSFont.boldSystemFont(ofSize: 14.0)
    addSubview(user)
    
    time.stringValue = "13:01"
    time.isEditable = false
    time.backgroundColor = NSColor.white
    time.textColor = NSColor.lightGray
    time.isBordered = false
    time.font = NSFont.systemFont(ofSize: 14.0)
    addSubview(time)
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
