//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

class ComposeMessage: NSView, NSTextFieldDelegate {
  
  let text = NSTextField(frame: NSMakeRect(5, 5, 600, 50))
  
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    
    if commandSelector == #selector(NSResponder.insertNewline(_:)) {
      
      if text.stringValue.hasPrefix("/token ") {
        let tokens = text.stringValue.components(separatedBy: " ")
        Swift.print("www \(tokens)")
      }
          // UserDefaults.standard.removeObject(forKey: "token")
        // UserDefaults.standard.setValue(customer.value(forKey: "username"), forKey: "username")
        // let username = UserDefaults.standard.value(forKey: "username")

      
      NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "sendMessage"),
        object: text.stringValue)
      text.stringValue = ""
      
      return true
    }
    return false
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)
    translatesAutoresizingMaskIntoConstraints = true
    
    wantsLayer = true
    layer?.backgroundColor = NSColor.darkGray.cgColor
    
    text.stringValue = ""
    text.isEditable = true
    text.backgroundColor = NSColor.white
    text.isBordered = true
    text.font = NSFont.systemFont(ofSize: 14.0)
    text.delegate = self;
    addSubview(text)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
