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

class ComposeMessage: NSView, NSTextFieldDelegate {
  
  let text = NSTextField(frame: NSMakeRect(5, 5, 600, 50))
  var disposeBag = DisposeBag()
  
  func addToArrayOfTeams(id: String) {
    
     let existing = UserDefaults.standard.value(forKey: "bcc_teams")
     
     if (existing != nil) {
       let defaults = UserDefaults.standard
       var to_save = defaults.value(forKey: "bcc_teams") as! Array<String>
       to_save.append(id)
       defaults.set(to_save, forKey: "bcc_teams")
     } else {
       let to_save = [id]
       let defaults = UserDefaults.standard
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
        let JSONString = jsonTeam.toJSONString(prettyPrint: false)
        
        Swift.print("\(String(describing: JSONString))")
        
        let defaults = UserDefaults.standard
        defaults.set(JSONString, forKey: "bcc_\(team.id!)")
        self.addToArrayOfTeams(id: team.id!)
        
        NotificationCenter.default.post(
          name:NSNotification.Name(rawValue: "newTeamAdded"),
          object: jsonTeam)
    },
      onError: { error in
        
    }).addDisposableTo(disposeBag)
  }
  
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    
    if commandSelector == #selector(NSResponder.insertNewline(_:)) {
      
      if text.stringValue.hasPrefix("/token ") {
        let tokens = text.stringValue.components(separatedBy: " ")
        text.stringValue = ""
        addNewTeam(token: tokens[1])
        return true
      } else if text.stringValue.hasPrefix("/tokens") {
      } else if text.stringValue.hasPrefix("/logout") {
        text.stringValue = ""
        let existing = UserDefaults.standard.value(forKey: "bcc_teams") as! Array<String>
        for team in existing {
          UserDefaults.standard.removeObject(forKey: "bcc_\(team)")
        }
        UserDefaults.standard.removeObject(forKey: "bcc_teams")
        return true
      }
      
      NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "sendMessage"),
        object: text.stringValue)
      text.stringValue = ""
      
      return true
    }
    return false
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    //autoresizingMask.insert(NSAutoresizingMaskOptions.viewMinYMargin)
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewMaxYMargin)
    translatesAutoresizingMaskIntoConstraints = true
    
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
