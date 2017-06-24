//
//  CompanyList.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Moya
import RxSwift
import Alamofire
import RealmSwift

class ButtonWithStringTag: NSButton {
  var stringTag: String = ""
  var flavor: String = ""
  var team: Team?
  var channel: ChannelObject?
}

class ChannelWithRed: NSView {
  let reddot = NSImage(named: "reddot.png")
  let button = ButtonWithStringTag(frame: NSMakeRect(0,0,200,25))
  let red = NSImageView(frame: NSMakeRect(180,8,12,12))
  var team_id = ""
  var channel_id = ""
  
  func checkRedDotStatus(notification: NSNotification) {
    
    let json = notification.object as! [String: Any]
    if let c = json["channel"] {
      //NSLog("\(c) | \(self.channel_id)")
      if (c as! String) == self.channel_id {
        red.isHidden = false
      }
    }
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    red.image = reddot
    red.isHidden = true
    
    addSubview(button)
    addSubview(red)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(checkRedDotStatus),
                                           name: NSNotification.Name(rawValue: "rtmMessage"),
                                           object: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ChannelList: NSScrollView {
    
  let list = NSView(frame: NSMakeRect(0,0,220,1560+900))
  var disposeBag = DisposeBag()
  var team: Team?
  
 
  
  func makeListFromCol(cos: Results<ChannelObject>) {
    self.list.subviews = []
    
    for d in cos {
      self.addChannel(i: self.list.subviews.count, title: d.name,
                      id: d.id, flavor: d.flavor,
                      red: d.possibly_new,
                      channel: d,
                      team: self.team!)
    }

  }
  
  func companyDidChange(notification: NSNotification) {
    let team = notification.object as! Team
    self.team = team
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "rtmMessage"),
      object: ["team": team.id, "channel": "off", "text": ""])

    
    let realm = try! Realm()
    let sortProperties = [SortDescriptor(keyPath: "ts", ascending: false)]
    let cos = realm.objects(ChannelObject.self).filter("team = %@", team.id!).sorted(by: sortProperties)
    
    
    if (cos.count != 0) {
      //let uf = UnreadFinder()
      //uf.channelsWithUnread(team: team)
      
      makeListFromCol(cos: cos)
      return
    }
    
  }
  
  func addChannel(i: Int, title: String, id: String, flavor: String,
                  red: Int, channel: ChannelObject, team: Team) {
    let cwr = ChannelWithRed(frame: NSMakeRect(10,(CGFloat(i*30)),200,25))
    cwr.button.title = title
    cwr.button.tag = i
    cwr.button.stringTag = id
    cwr.channel_id = id
    cwr.button.channel = channel
    cwr.button.flavor = flavor
    cwr.button.team = team
    cwr.button.target = self
    cwr.button.action = #selector(changeChannel)
    
    if red == 1 {
      cwr.red.isHidden = false
    }
    
    list.addSubview(cwr)
  }
  
  func changeChannel(sender:ButtonWithStringTag) {
    let cwr = list.subviews[sender.tag] as! ChannelWithRed
    cwr.red.isHidden = true
    
    let realm = try! Realm()
    let team = cwr.button.team?.id!
    let cos = realm.objects(ChannelObject.self).filter("team = %@", team as Any)
    for c in cos {
      if c.id == cwr.channel_id {
        try! realm.write {
          c.possibly_new = 0
        }
      }
    }

    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "channelDidChange"),
      object: sender)
    
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(companyDidChange),
                                           name: NSNotification.Name(rawValue: "companyDidChange"),
                                           object: nil)
    /*
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(sortByLastMsgDate),
                                           name: NSNotification.Name(rawValue: "sortByLastMsgDate"),
                                           object: nil) */
    
    wantsLayer = true
    
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
 
