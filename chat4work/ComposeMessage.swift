//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Moya
import RxSwift
import RealmSwift

class ComposeMessage: NSView, NSTextFieldDelegate {
  
  let text = NSTextField(frame: NSMakeRect(5, 5, 600, 50))
  var disposeBag = DisposeBag()
  var channel: ChannelObject?
  
  func channelDidChange(notification: NSNotification) {
    let b = notification.object as! ButtonWithStringTag
    channel = b.channel
  }
  
  func pasteText(notification: NSNotification) {
    let b = notification.object as! String
    text.stringValue = text.stringValue + "" + b
  }
  
  func addToArrayOfTeams(id: String) {
    
    let defaults = UserDefaults.standard
    let existing = UserDefaults.standard.value(forKey: "bcc_teams")
    
    if (existing != nil) {
      var to_save = defaults.value(forKey: "bcc_teams") as! Array<String>
      to_save.append(id)
      defaults.set(to_save, forKey: "bcc_teams")
    } else {
      let to_save = [id]
      defaults.set(to_save, forKey: "bcc_teams")
    }
  }
  
  func addNewTeam(token: String) {
    
    let provider = RxMoyaProvider<ChatService>()
    let channelApi = ChannelApiImpl(provider: provider)
    
    channelApi.getTeamInfo(token: token).subscribe(
      onNext: { team in
        
        Swift.print("\(team)")
        var jsonTeam = Team(withToken: token, id: team.id!)!
        jsonTeam.icon = team.icon
        jsonTeam.name = team.name
        jsonTeam.url = team.url
        jsonTeam.index = 1
        let JSONString = jsonTeam.toJSONString(prettyPrint: false)
        
        Swift.print("\(String(describing: JSONString))")
        
        let defaults = UserDefaults.standard
        defaults.set(JSONString, forKey: "bcc_\(team.id!)")
        self.addToArrayOfTeams(id: team.id!)
        
        let existing = UserDefaults.standard.value(forKey: "bcc_teams")
        
        if (existing != nil) {
          
          let defaults = UserDefaults.standard
          let to_save = defaults.value(forKey: "bcc_teams") as! Array<String>
          jsonTeam.index = to_save.count-1
        }
        NotificationCenter.default.post(
          name:NSNotification.Name(rawValue: "newTeamAdded"),
          object: jsonTeam)
    },
      onError: { error in
        
    }).addDisposableTo(disposeBag)
  }
  
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    
    if commandSelector == #selector(NSResponder.insertNewline(_:)) {
      let realm = try! Realm()

      if text.stringValue.hasPrefix("/token ") {
        let tokens = text.stringValue.components(separatedBy: " ")
        text.stringValue = ""
        addNewTeam(token: tokens[1])
        return true
      } else if text.stringValue.hasPrefix("/logout all") {
        let existing = UserDefaults.standard.value(forKey: "bcc_teams") as! Array<String>
        for team in existing {
          UserDefaults.standard.removeObject(forKey: "bcc_\(team)")
        }
        UserDefaults.standard.removeObject(forKey: "bcc_teams")
        
        try! realm.write {
          realm.deleteAll()
        }
        
        exit(1)
      } else if text.stringValue.hasPrefix("/logout") {
        text.stringValue = ""
        
        NotificationCenter.default.post(
          name:NSNotification.Name(rawValue: "teamLogout"),
          object: nil)
        
        return true
      }
      
      let provider = RxMoyaProvider<ChatService>()
      let channelApi = ChannelApiImpl(provider: provider)
      
      let def = ""
      let json = UserDefaults.standard.value(forKey: "bcc_\(channel?.team ?? def)") as! String
      let team = Team(JSONString: json)!
      
      let say = text.stringValue
      text.stringValue = ""
      channelApi.postMessage(token: team.token!, id: (channel?.id)!, text: say).subscribe(
        onNext: { message in
          
          //NSLog("\(String(describing: message.ts))")
          
          let mo = MessageObject()
          mo.ts = message.ts!
          mo.tsd = Double(mo.ts)!
          mo.channel = (self.channel?.id)!
          
          mo.text = say
          mo.user = message.user!
          mo.username = "me"
          
          let pkey = "\(team.id!).\(mo.user)"
          if let existing = realm.object(ofType: UserObject.self,
                                         forPrimaryKey: pkey as AnyObject) {
            mo.username = existing.name
            
          }
          
          mo.team = team.id!
          mo.id = "\(team.id!).\(self.channel?.id ?? "").\(mo.ts)"
          
          let existing = realm.object(ofType: MessageObject.self, forPrimaryKey: mo.id as AnyObject)
          
          if (existing == nil) {
            try! realm.write {
              realm.add(mo)
            }
          }
          
          NotificationCenter.default.post(
            name:NSNotification.Name(rawValue: "contentIsReady"),
            object: ["team": mo.team, "channel": mo.channel])
          
      },
        onError: { error in
          
      }).addDisposableTo(disposeBag)
    
      
      
      return true
    }
    return false
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)
    translatesAutoresizingMaskIntoConstraints = true
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(pasteText),
                                           name: NSNotification.Name(rawValue: "pasteText"),
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(channelDidChange),
                                           name: NSNotification.Name(rawValue: "channelDidChange"),
                                           object: nil)
    
    wantsLayer = true
    layer?.backgroundColor = NSColor.darkGray.cgColor
    
    text.stringValue = ""
    text.isEditable = true
    text.backgroundColor = NSColor.white
    text.isBordered = true
    text.font = NSFont.systemFont(ofSize: 14.0)
    text.delegate = self;
    addSubview(text)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
