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
