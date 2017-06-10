//
//  CompanyList.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage

class CompanyList: NSScrollView {
    
  let left = NSView(frame: NSMakeRect(0,0,70,1560+900))
  let image1 = NSImage(named: "logo1.png")
  let image2 = NSImage(named: "ibm_logo.png")
  let image3 = NSImage(named: "hp.png")
  let image4 = NSImage(named: "insta.png")
  let image5 = NSImage(named: "mena.png")
  
  func addIcon(i: Int, image: NSImage) {
    let imageView = NSButton(frame: NSMakeRect(10,(CGFloat(i*60)),50,50))
    imageView.image = image
    imageView.tag = i
    imageView.target = self
    imageView.action = #selector(changeCompany)
    imageView.alphaValue = 1.0
    left.addSubview(imageView)
  }

  func newTeamAdded(notification: NSNotification) {
    let url = notification.object as! String
    
    Alamofire.request(url).responseImage { response in
      
      if let image = response.result.value {
        self.addIcon(i: self.left.subviews.count, image: image)
      }
    }
    
  }
    
  func changeCompany(sender:NSButton) {
    
    if sender.tag > 0 {
      let existing = UserDefaults.standard.value(forKey: "bcc_tokens") as! Array<String>
      let token = existing[sender.tag-1]
      
      NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "companyDidChange"),
        object: token)
    }
    

    /*
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "channelDidChange"),
      object: "channel \(sender.tag)") */
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(newTeamAdded),
                                           name: NSNotification.Name(rawValue: "newTeamAdded"),
                                           object: nil)
    
    wantsLayer = true
    
    left.wantsLayer = true
    left.layer?.backgroundColor = NSColor.lightGray.cgColor
    for i in 0...0 {
      addIcon(i: i, image: image5!)
    }
    let existing = UserDefaults.standard.value(forKey: "bcc_tokens")
    
    if (existing != nil) {
      let existingTokens = existing as! Array<String>
      for token in existingTokens {
        NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "newTeamAdded"),
        object: UserDefaults.standard.value(forKey: "bcc_icon_\(token)"))
      }
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
 
