//
//  MarkListener.swift
//  boring-company-chat
//
//  Created by A Arrow on 6/23/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Moya
import RxSwift
import Alamofire
import RealmSwift

class MarkListener: NSObject {

  func markChannel(notification: NSNotification) {
    
    let data = notification.object as! [String: Any]
    
    let now = data["now"] as! TimeInterval
    let channel = data["channel"] as! String
    let ts = data["ts"] as! String
    let team = data["team"] as! Team
    
    NSLog("\(team.id)")
    
    
  }
  
  
  override init() {
    super.init();
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(markChannel),
                                           name: NSNotification.Name(rawValue: "markChannel"),
                                           object: nil)
    
  }
}
