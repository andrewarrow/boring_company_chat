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
  var disposeBag = DisposeBag()
  
  var lastMarked = ["c1": 12345.0]
  
  func markChannel(notification: NSNotification) {
    
    let data = notification.object as! [String: Any]
    
    let now = data["now"] as! TimeInterval
    let channel = data["channel"] as! String
    var talkAgain = false
    
    if lastMarked[channel] == nil {
      talkAgain = true
    } else {
      let current = NSDate().timeIntervalSince1970
      let delta = current - lastMarked[channel]!
      NSLog("d \(delta)")
      if delta < 5.0 {
        NSLog("5")
        talkAgain = true
      }
    }
    
    lastMarked[channel] = now
    
    if talkAgain == true {
      return
    }
    
    let ts = data["ts"] as! String
    let team = data["team"] as! Team
    let flavor = data["flavor"] as! String
    
    let provider = RxMoyaProvider<ChatService>()
    let channelApi = ChannelApiImpl(provider: provider)
    
    var o: Observable<Messages>? = nil
    
    if flavor == "channels" {
      o = channelApi.markChannel(token: team.token!, id: channel, ts: ts)
    }
    else if flavor == "groups" {
      o = channelApi.markGroup(token: team.token!, id: channel, ts: ts)
    }
    else {
      o = channelApi.markChannel(token: team.token!, id: channel, ts: ts)
    }
    
     o?.subscribe(
     onNext: { messages in
       NSLog("here")
     },
     onError: { error in
       NSLog("err")
     }).addDisposableTo(disposeBag)
    
  }
  
  
  override init() {
    super.init();
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(markChannel),
                                           name: NSNotification.Name(rawValue: "markChannel"),
                                           object: nil)
    
  }
}
