//
//  AppDelegate.swift
//  chat4work
//
//  Created by A Arrow on 6/5/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
  var win: NSWindow?
    
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  @IBAction func sortByLastMsgDate(_ sender:NSObject) {
    
    win = NSWindow(contentRect: NSMakeRect(100, 100, 600, 200),
                       styleMask: NSResizableWindowMask,
                       backing: NSBackingStoreType.buffered, defer: true)
    
    let nswc = NSWindowController(window: win)
    //win?.makeKeyAndOrderFront(self)
    
    NSApplication.shared().keyWindow?.beginSheet(nswc.window!, completionHandler: { [unowned self] (returnCode) -> Void in
        if returnCode == NSAlertFirstButtonReturn {
            //self.dataModel.removeAll()
        }
    })

    
    NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "sortByLastMsgDate"),
        object: sender)
  }
    
  @IBAction func pref(_ sender:NSObject) {
 
    //  "https://slack.com/oauth/authorize?client_id=3192071428.96285304358&scope=client&redirect_uri=https://higher.team/wxslak"
    //let url = URL(string: "https://higher.team/tokens")
    let url = URL(string: "https://slack.com/oauth/authorize?client_id=124337043952.195173593026&scope=client&redirect_uri=https://higher.team/slack")
    NSWorkspace.shared().open(url!)
    
  }
}

