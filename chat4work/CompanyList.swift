//
//  CompanyList.swift
//  chat4work
//
//  Created by A Arrow on 6/7/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import Starscream
import Moya
import RxSwift

class CompanyWithRed: NSView {
  let reddot = NSImage(named: "reddot.png")
  let button = NSButton(frame: NSMakeRect(0,0,50,50))
  let red = NSImageView(frame: NSMakeRect(42,38,12,12))

  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    red.image = reddot
    
    addSubview(button)
    addSubview(red)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CompanyList: NSScrollView, WebSocketDelegate {
    
  let left = NSView(frame: NSMakeRect(0,0,70,1560+900))
  let image5 = NSImage(named: "mena.png")
  var sockets = [WebSocket]()
  var disposeBag = DisposeBag()
 
  func websocketDidConnect(socket: WebSocket) {
    Swift.print("websocket is connected")
    //socket.write(string: "hello there!")
  }
  
  func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
    if let e = error {
      Swift.print("websocket is disconnected: \(e.localizedDescription)")
    } else {
      Swift.print("websocket disconnected")
    }
  }
  
  func websocketDidReceiveMessage(socket: WebSocket, text: String) {
    Swift.print("RT: \(text)")
    
    do {
      let data = text.data(using: String.Encoding.utf8, allowLossyConversion: false)!
      let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      let etype = json?["type"] as? String
      if etype == "message" {
        NotificationCenter.default.post(
          name:NSNotification.Name(rawValue: "rtmMessage"),
          object: json)
      }
    } catch {
      Swift.print("Error deserializing JSON: \(error)")
    }

    
    //{"type":"message",
    //"channel":"D18T96VJM",
    //"user":"U025M33EJ",
    //"text":"wefwefwe",
    //"ts":"1497128451.247014",
    //"source_team":"T025K4ALN",
    //"team":"T025K4ALN"}
    
    /*RT: {"type":"im_marked","channel":"D18T96VJM","ts":"1497128451.247014","dm_count":0,"unread_count_display":0,"num_mentions_display":0,"mention_count_display":0,"event_ts":"1497128452.824439"} */
  }
  
  func websocketDidReceiveData(socket: WebSocket, data: Data) {
    Swift.print("RD: \(data.count)")
  }
  
  func addIcon(i: Int, image: NSImage) {
    let cwr = CompanyWithRed(frame: NSMakeRect(10,(CGFloat(i*60)),60,50))
    cwr.button.image = image
    cwr.button.tag = i
    cwr.button.target = self
    cwr.button.action = #selector(changeCompany)
    left.addSubview(cwr)
  }

  func newTeamAdded(notification: NSNotification) {
    let team = notification.object as! Team
    let token = team.token

    let existing = UserDefaults.standard.value(forKey: "bcc_tokens") as! Array<String>
    
    var index = 0
    for (i,t) in existing.enumerated() {
      if t == token {
        index = i
        break
      }
    }
    
    let url = UserDefaults.standard.value(forKey: "bcc_icon_\(token ?? "123")") as! String

    let provider = RxMoyaProvider<ChatService>()
    let channelApi = ChannelApiImpl(provider: provider)
    
    Alamofire.request(url).responseImage { response in
      
      if let image = response.result.value {
        self.addIcon(i: index+1, image: image)
      
        channelApi.rtmConnect(token: token!).subscribe(
          onNext: { team in
            let ws = WebSocket(url: URL(string: team.url!)!)
            ws.delegate = self
            ws.connect()
            self.sockets.append(ws)

        },
          onError: { error in
            
        }).addDisposableTo(self.disposeBag)
        
        
      }
    }
    
  }
    
  func changeCompany(sender:NSButton) {
    
    if sender.tag > 0 {
      let existing = UserDefaults.standard.value(forKey: "bcc_tokens") as! Array<String>
      let token = existing[sender.tag-1]
      
      NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "companyDidChange"),
        object: token)
    }
    

    /*
    NotificationCenter.default.post(
      name:NSNotification.Name(rawValue: "channelDidChange"),
      object: "channel \(sender.tag)") */
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame:frameRect);
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(newTeamAdded),
                                           name: NSNotification.Name(rawValue: "newTeamAdded"),
                                           object: nil)
    
    wantsLayer = true
    
    left.wantsLayer = true
    left.layer?.backgroundColor = NSColor.lightGray.cgColor
    for i in 0...0 {
      addIcon(i: i, image: image5!)
    }
    let existing = UserDefaults.standard.value(forKey: "bcc_tokens")
    
    if (existing != nil) {
      
      let existingTokens = existing as! Array<String>
      for token in existingTokens {
        let team = Team(withToken: token)
        
        NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "newTeamAdded"),
        object: team)
      }
    }

    translatesAutoresizingMaskIntoConstraints = true
    autoresizingMask.insert(NSAutoresizingMaskOptions.viewHeightSizable)
    
    left.translatesAutoresizingMaskIntoConstraints = true
    left.autoresizingMask.insert(NSAutoresizingMaskOptions.viewHeightSizable)

    documentView = left
    hasVerticalScroller = false
    //documentView?.scroll(NSPoint(x: 0, y:200))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
 
