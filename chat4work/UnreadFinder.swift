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
  
  func channelsWithUnread(team: Team) {
    
    //var listOfRed = Array<String>()
    
    let realm = try! Realm()
    let col = realm.objects(ChannelObjectList.self).filter("team = %@", team.id!).first
    
    let group = DispatchGroup()
    
    for c in (col?.list)! {
    
      let url = "https://slack.com/api/\(c.flavor).history?token=\(team.token ?? "")&channel=\(c.id)&count=1&unreads=1"
      
      group.enter()
      
      Alamofire.request(url).responseJSON { response in
        if let json = response.result.value as? [String: Any] {
          
          //unread_count_display
          if let ucd = json["unread_count_display"] {
            let ucdi = ucd as! Int
            if ucdi > 0 {
              //listOfRed.append(c.id)
              
              try! realm.write {
                //turn on red for team
                c.possibly_new = 1
              }
            }
          }
          
          //NSLog("\(json)")
          
        }
        
        group.leave()
      }
    }
    
    
    
    group.notify(queue: DispatchQueue.main, execute: {
     //NSLog("\(listOfRed)")
      
    })
  }
}
