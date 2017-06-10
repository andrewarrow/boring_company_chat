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
      channelApi.getChannels(token: token),
      channelApi.getGroups(token: token),
      channelApi.getIMs(token: token)) { (channels, groups, ims) in
        if let c = channels.results {
          
          c.forEach({
            (channel) in
            self.addChannel(i: self.list.subviews.count, title: channel.name!)
          })
        }
        
        if let g = groups.results {
          g.forEach({
            (group) in
            self.addChannel(i: self.list.subviews.count, title: group.name!)
          })
        }
        
        if let i = ims.results {
          i.forEach({
            (im) in
            self.addChannel(i: self.list.subviews.count, title: im.user!)
          })
        }
      }
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
      .subscribe()
      .addDisposableTo(disposeBag)
  }
  
  func addChannel(i: Int, title: String) {
    let imageView = NSButton(frame: NSMakeRect(10,(CGFloat(i*30)),200,25))
    imageView.title = title
    imageView.tag = i
    imageView.target = self
    imageView.action = #selector(changeChannel)
    imageView.alphaValue = 1.0
    list.addSubview(imageView)
  }
  
  func changeChannel(sender:NSButton) {
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "channelDidChange"),
      object: "channel \(sender.tag)")
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
 
