//
//  UnreadFinder.swift
//  boring-company-chat
//
//  Created by A Arrow on 6/22/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Moya
import RxSwift
import Alamofire
import RealmSwift

class UnreadFinder: NSObject {
  
  var disposeBag = DisposeBag()
  
  func cacheChannels(team: Team) {
    let realm = try! Realm()
    var col = realm.objects(ChannelObjectList.self).filter("team = %@", team.id!).first
    
    if (col != nil) {
      channelsWithUnread(team: team)
      return
    }
    
    let group = DispatchGroup()
    
    col = ChannelObjectList()
    col?.team = team.id!
    
    let flavors = ["channels", "groups", "im"]
    let flavors_map = ["channels": "channels", "groups": "groups", "im": "ims"]
    for f in flavors {
      let url = "https://slack.com/api/\(f).list?token=\(team.token ?? "")"
      
      group.enter()
      
      Alamofire.request(url).responseJSON { response in
        if let json = response.result.value as? [String: Any] {
          
          let channels = json[flavors_map[f]!] as! Array<[String: Any]>
          
          for c in channels {
            
            let co = ChannelObject()
            co.id = c["id"] as! String
            co.flavor = f
            if f == "im" {
              co.name = co.find_name(user: c["user"] as! String, team: team.id!)
            } else {
              co.name = c["name"] as! String
            }
            col?.list.append(co)
          }
        }
        
        group.leave()
      }
    }
    
    group.notify(queue: DispatchQueue.main, execute: {
      let realm = try! Realm()
      
      try! realm.write {
        realm.add(col!)
      }
      
      self.channelsWithUnread(team: team)
      
    })
  }
  
  
  func cacheUsers(team: Team) {
    let realm = try! Realm()
    var uol = realm.objects(UserObjectList.self).filter("team = %@", team.id!).first
    
    if (uol != nil) {
      cacheChannels(team: team)
      return
    }
    
    let group = DispatchGroup()
    
    uol = UserObjectList()
    uol?.team = team.id!
    
    let url = "https://slack.com/api/users.list?token=\(team.token ?? "")"
    
    group.enter()
    
    Alamofire.request(url).responseJSON { response in
      if let json = response.result.value as? [String: Any] {
        
        let members = json["members"] as! Array<[String: Any]>
        
        for m in members {
          let uo = UserObject()
          uo.name = m["name"] as! String
          uo.id = m["id"] as! String
          uol?.list.append(uo)
        }
      }
      
      group.leave()
    }
    
    group.notify(queue: DispatchQueue.main, execute: {
      let realm = try! Realm()
      
      try! realm.write {
        realm.add(uol!)
      }
      
      self.cacheChannels(team: team)
      
    })
  }
  
  func old(team: Team) {
    NSLog("1")
    let realm = try! Realm()
    let col: ChannelObjectList = ChannelObjectList()
    col.team = team.id!
    
    let provider = RxMoyaProvider<ChatService>()
    let channelApi = ChannelApiImpl(provider: provider)
    
    NSLog("2")
    Observable.zip(
      channelApi.getUsers(token: team.token!),
      channelApi.getChannels(token: team.token!),
      channelApi.getGroups(token: team.token!),
      channelApi.getIMs(token: team.token!)) { (users, channels, groups, ims) in
        var UserHash = ["1":"2"]
        NSLog("3")
        if let u = users.results {
          
          u.forEach({
            (user) in
            UserHash[user.id!] = user.name
          })
        }
        
        
        if let c = channels.results {
          
          c.forEach({
            (channel) in
            
            let co = ChannelObject()
            co.id = channel.id!
            co.flavor = "channels"
            co.name = channel.name!
            col.list.append(co)
          })
        }
        
        if let g = groups.results {
          g.forEach({
            (group) in
            
            let co = ChannelObject()
            co.id = group.id!
            co.flavor = "groups"
            co.name = group.name!
            col.list.append(co)
          })
        }
        
        if let i = ims.results {
          i.forEach({
            (im) in
            
            let co = ChannelObject()
            co.id = im.id!
            co.flavor = "ims"
            co.name = UserHash[im.user!]!
            col.list.append(co)
          })
        }
        
        NSLog("w \(col.list.count) items")
        
        try! realm.write {
          realm.add(col)
        }
        
      }
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
      .subscribe(onError: { error in
        NSLog("1111 \(error)")
      })
      .addDisposableTo(disposeBag)
  }
  
  /*
   func downloadAndCacheChannels(team: Team) {
   
   let col: ChannelObjectList = ChannelObjectList()
   col.team = team.id
   
   let group = DispatchGroup()
   
   for sv in list.subviews {
   let cwr = sv as! ChannelWithRed
   
   let team = cwr.button.team
   
   let flavor = cwr.button.flavor
   let token = team?.token!
   let id = cwr.button.stringTag
   
   //let ob = channelApi.getHistoryByFlavor(token: token!, id:id, flavor: flavor, count: 1)
   
   let url = "https://slack.com/api/\(flavor).history?token=\(token ?? "")&channel=\(id)&count=1"
   
   //Swift.print("Request: \(url)")
   group.enter()
   
   Alamofire.request(url).responseJSON { response in
   //Swift.print("response: \(response)")
   if let json = response.result.value as? [String: Any] {
   
   let messages = json["messages"]
   if messages != nil {
   let list = json["messages"] as! NSArray
   if list.count > 0 {
   let message = list[0] as? [String: Any]
   let ts = message?["ts"] as! String
   let tsd = Double(ts)
   let d = ChannelObject()
   d.ts = tsd!
   d.id = id
   d.flavor = flavor
   d.name = cwr.button.title
   col.list.append(d)
   //sortList.append(d)
   //Swift.print("JSON: \(tsd)")
   }
   }
   }
   //
   group.leave()
   }
   }
   
   
   
   group.notify(queue: DispatchQueue.main, execute: {
   
   let sortList = col.list.sorted (by: { $0.ts > $1.ts })
   
   self.list.subviews = []
   
   for d in sortList {
   self.addChannel(i: self.list.subviews.count, title: d.name,
   id: d.id, flavor: d.flavor,
   red: 0,
   team: self.team!)
   }
   
   let realm = try! Realm()
   
   try! realm.write {
   realm.add(col)
   }
   
   })
   }*/
  
  func channelsWithUnread(team: Team) {
    
    let realm = try! Realm()
    let col = realm.objects(ChannelObjectList.self).filter("team = %@", team.id!).first
    
    let group = DispatchGroup()
    
    for c in (col?.list)! {
      
      let url = "https://slack.com/api/\(c.flavor).history?token=\(team.token ?? "")&channel=\(c.id)&count=1&unreads=1"
      //NSLog("\(url)")
      group.enter()
      
      Alamofire.request(url).responseJSON { response in
        if let json = response.result.value as? [String: Any] {
          
          if let messages = json["messages"] {
            let list = messages as! NSArray
            if list.count > 0 {
              let message = list[0] as? [String: Any]
              let ts = message?["ts"] as! String
              let tsd = Double(ts)
              
              try! realm.write {
                c.ts = tsd!
              }
            }
          }
          
          if let ucd = json["unread_count_display"] {
            let ucdi = ucd as! Int
            if ucdi > 0 {
              
              try! realm.write {
                c.possibly_new = 1
              }
              
              NotificationCenter.default.post(
                name:NSNotification.Name(rawValue: "rtmMessage"),
                object: ["team": team.id, "channel": "on"])
              
            }
          }
          
          //TODO ts as well
          
        }
        
        group.leave()
      }
    }
    
    
    
    group.notify(queue: DispatchQueue.main, execute: {
      
      
    })
  }
}
