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

class ButtonWithStringTag: NSButton {
  var stringTag: String = ""
  var flavor: String = ""
}

class ChannelList: NSScrollView {
    
  let list = NSView(frame: NSMakeRect(0,0,220,1560+900))
  var disposeBag = DisposeBag()
  
  func companyDidChange(notification: NSNotification) {
    let token = notification.object as! String
   // let name = UserDefaults.standard.value(forKey: "bcc_name_\(token)")
    
    let provider = RxMoyaProvider<ChatService>()
    let channelApi = ChannelApiImpl(provider: provider)
    
    self.list.subviews = []
    
    Observable.zip(
      channelApi.getUsers(token: token),
      channelApi.getChannels(token: token),
      channelApi.getGroups(token: token),
      channelApi.getIMs(token: token)) { (users, channels, groups, ims) in
        var UserHash = ["1":"2"]
        
        if let u = users.results {
          
          u.forEach({
            (user) in
            UserHash[user.id!] = user.name
          })
        }
        
        
        if let c = channels.results {
          
          c.forEach({
            (channel) in
            self.addChannel(i: self.list.subviews.count, title: channel.name!,
                            id: channel.id!, flavor: "channel")
          })
        }
        
        if let g = groups.results {
          g.forEach({
            (group) in
            self.addChannel(i: self.list.subviews.count, title: group.name!, id: group.id!,
                            flavor: "group")
          })
        }
        
        if let i = ims.results {
          i.forEach({
            (im) in
            self.addChannel(i: self.list.subviews.count, title: UserHash[im.user!]!, id: im.id!,
                            flavor: "im")
          })
        }
      }
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
      .subscribe()
      .addDisposableTo(disposeBag)
  }
  
  func addChannel(i: Int, title: String, id: String, flavor: String) {
    let imageView = ButtonWithStringTag(frame: NSMakeRect(10,(CGFloat(i*30)),200,25))
    imageView.title = title
    imageView.tag = i
    imageView.stringTag = id
    imageView.flavor = flavor
    imageView.target = self
    imageView.action = #selector(changeChannel)
    imageView.alphaValue = 1.0
    list.addSubview(imageView)
  }
  
  func changeChannel(sender:ButtonWithStringTag) {
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
 
