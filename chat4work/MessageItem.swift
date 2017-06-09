//
//  CurrentCompany.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return prettyData
  } catch {
    return data // fallback to original data if it can't be serialized.
  }
}

class MessageItem: NSView {
  
  let user = NSTextField(frame: NSMakeRect(5, 220, 200, 25))
  let time = NSTextField(frame: NSMakeRect(150, 220, 200, 25))
  let msg = NSTextField(frame: NSMakeRect(5, 0, 680, 200))
  var sel1 = 0
  var sel2 = 0
  
  
  @IBAction func copy(_ sender:NSObject) {
    let pasteboard = NSPasteboard.general()
    pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
    pasteboard.setString(msg.stringValue, forType: NSPasteboardTypeString)
  }
  
  override func mouseDown(with event: NSEvent) {
    NSApplication.shared().keyWindow!.makeFirstResponder(self)
    
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "turnAllOff"),
      object: nil)
    
    msg.backgroundColor = NSColor.darkGray
    sel1 = 1
    
    let value = ProcessInfo.processInfo.environment["SLACK_TOKENS"]
    let tokens = value?.components(separatedBy: ",")
    let token = tokens?[4]
    
    /*
    GitHubProvider.request(.userRepositories(username)) { result in
      do {
        let response = try result.dematerialize()
        let value = try response.mapNSArray()
        self.repos = value
        self.tableView.reloadData()
      } catch {
        let printableError = error as? CustomStringConvertible
        let errorMessage = printableError?.description ?? "Unable to fetch from GitHub"
        self.showAlert("GitHub Fetch", message: errorMessage)
      }
     
     let blogs = json["channels"] as? [[String: Any]] {
     for blog in blogs {
     if let name = blog["id"] as? String {
     Swift.print("qqq1111 \(name)")
     }
     }
     }

     
      */
    
    //let provider = MoyaProvider<ChatService>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    let provider = MoyaProvider<ChatService>()
    provider.request(.showAccounts(token: token!)) { result in
      switch result {
      case let .success(moyaResponse):

        do {
            let json = try JSONSerialization.jsonObject(with: moyaResponse.data) as? [String: Any]
          let channels = json?["channels"] as? [[String: Any]]
          for channel in channels! {
            let name = channel["name"]
            Swift.print("qqq1111 \(name)")
          }
          
        } catch {
          Swift.print("Error deserializing JSON: \(error)")
        }
        
        
        //var data = moyaResponse.data
        //data = JSONResponseDataFormatter(moyaResponse.data)
        //data["channels"]//, id, num_members
        //let statusCode = moyaResponse.statusCode
        //Swift.print("qqq1111 \(data)")


      case let .failure(error):
        Swift.print("www")
      
      }
    }
  }
  
  func turnOff() {
    sel1 = 0
    msg.backgroundColor = NSColor.white
  }

  override func mouseDragged(with event: NSEvent) {
    //Swift.print("Wefwef")
  }

  override func mouseUp(with event: NSEvent) {
    Swift.print("Wefwef")
  }

  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    //wantsLayer = true
    //layer?.backgroundColor = NSColor.darkGray.cgColor
    
    msg.stringValue = ""
    msg.isEditable = false
    msg.backgroundColor = NSColor.white
    msg.isBordered = false
    msg.font = NSFont.systemFont(ofSize: 14.0)
    addSubview(msg)

    user.stringValue = "andrew"
    user.isEditable = false
    user.backgroundColor = NSColor.white
    user.isBordered = false
    user.font = NSFont.systemFont(ofSize: 14.0)
    addSubview(user)
    
    time.stringValue = "13:01"
    time.isEditable = false
    time.backgroundColor = NSColor.white
    time.isBordered = false
    time.font = NSFont.systemFont(ofSize: 14.0)
    addSubview(time)
  }
  
  func getStringValue() -> String {
    return msg.stringValue
  }
  
  func setStringValue(val: String) {
    msg.stringValue = val
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
