//
//  AppDelegate.swift
//  chat4work
//
//  Created by A Arrow on 6/5/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
  var win: NSWindow?
  var alert: NSAlert?
    
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    let config = Realm.Configuration(
      schemaVersion: 1,
      
      migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 1) {
      
        }
    })
    
    Realm.Configuration.defaultConfiguration = config
    
    try! Realm()
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  @IBAction func paste(_ sender: AnyObject) {
    NSLog("hi")
    let pasteboard = NSPasteboard.general()
    
    //let item1 = pasteboard.pasteboardItems?[0]
    
    // kUTTypeJPEG
    // kUTTypeGIF
    
    // kUTTypeUTF8PlainText
    
    if let data = pasteboard.data(forType: kUTTypeUTF8PlainText as String) {
      let pb = String(data: data, encoding: .utf8)
      
      NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "pasteText"),
        object: pb)
      
      return
    }
    
    if let data = pasteboard.data(forType: kUTTypePNG as String) {
      
      NSLog("\(data)")
    }
  }
  
  @IBAction func listChannelsWithCount(_ sender:NSObject) {
NSLog("Wefwfe")
  }
  
  @IBAction func sortByLastMsgDate(_ sender:NSObject) {
    
    /*
    win = NSWindow(contentRect: NSMakeRect(100, 100, 600, 200),
                       styleMask: NSResizableWindowMask,
                       backing: NSBackingStoreType.buffered, defer: true)
    win.addButton(withTitle: "Yes")
    
    let nswc = NSWindowController(window: win)
    //win?.makeKeyAndOrderFront(self)
    
    NSApplication.shared().keyWindow?.beginSheet(nswc.window!, completionHandler: { [unowned self] (returnCode) -> Void in
        if returnCode == NSAlertFirstButtonReturn {
            //self.dataModel.removeAll()
        }
    })*/
    
    self.alert = NSAlert()
    alert?.messageText = "S O R T I N G"
    alert?.addButton(withTitle: "Cancel")
    alert?.informativeText = "Sorting... 1% done."
    
    alert?.beginSheetModal(for: (NSApplication.shared().keyWindow)!, completionHandler: { [unowned self] (returnCode) -> Void in
        if returnCode == NSAlertFirstButtonReturn {
            //self.dataModel.removeAll()
        }
    })

    
    NotificationCenter.default.post(
        name:NSNotification.Name(rawValue: "sortByLastMsgDate"),
        object: alert)
  }
    
  @IBAction func pref(_ sender:NSObject) {
 
    //  "https://slack.com/oauth/authorize?client_id=3192071428.96285304358&scope=client&redirect_uri=https://higher.team/wxslak"
    //let url = URL(string: "https://higher.team/tokens")
    let url = URL(string: "https://slack.com/oauth/authorize?client_id=124337043952.195173593026&scope=client&redirect_uri=https://higher.team/slack")
    NSWorkspace.shared().open(url!)
    
  }
}

struct DateComponentUnitFormatter {
  
  private struct DateComponentUnitFormat {
    let unit: Calendar.Component
    
    let singularUnit: String
    let pluralUnit: String
    
    let futureSingular: String
    let pastSingular: String
  }
  
  private let formats: [DateComponentUnitFormat] = [
    
    DateComponentUnitFormat(unit: .year,
                            singularUnit: "year",
                            pluralUnit: "years",
                            futureSingular: "Next year",
                            pastSingular: "Last year"),
    
    DateComponentUnitFormat(unit: .month,
                            singularUnit: "month",
                            pluralUnit: "months",
                            futureSingular: "Next month",
                            pastSingular: "Last month"),
    
    DateComponentUnitFormat(unit: .weekOfYear,
                            singularUnit: "week",
                            pluralUnit: "weeks",
                            futureSingular: "Next week",
                            pastSingular: "Last week"),
    
    DateComponentUnitFormat(unit: .day,
                            singularUnit: "day",
                            pluralUnit: "days",
                            futureSingular: "Tomorrow",
                            pastSingular: "Yesterday"),
    
    DateComponentUnitFormat(unit: .hour,
                            singularUnit: "hour",
                            pluralUnit: "hours",
                            futureSingular: "In an hour",
                            pastSingular: "An hour ago"),
    
    DateComponentUnitFormat(unit: .minute,
                            singularUnit: "minute",
                            pluralUnit: "minutes",
                            futureSingular: "In a minute",
                            pastSingular: "A minute ago"),
    
    DateComponentUnitFormat(unit: .second,
                            singularUnit: "second",
                            pluralUnit: "seconds",
                            futureSingular: "Just now",
                            pastSingular: "Just now"),
    
    ]
  
  func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
    for format in self.formats {
      let unitValue: Int
      
      switch format.unit {
      case .year:
        unitValue = dateComponents.year ?? 0
      case .month:
        unitValue = dateComponents.month ?? 0
      case .weekOfYear:
        unitValue = dateComponents.weekOfYear ?? 0
      case .day:
        unitValue = dateComponents.day ?? 0
      case .hour:
        unitValue = dateComponents.hour ?? 0
      case .minute:
        unitValue = dateComponents.minute ?? 0
      case .second:
        unitValue = dateComponents.second ?? 0
      default:
        assertionFailure("Date does not have requried components")
        return ""
      }
      
      switch unitValue {
      case 2 ..< Int.max:
        return "\(unitValue) \(format.pluralUnit) ago"
      case 1:
        return useNumericDates ? "\(unitValue) \(format.singularUnit) ago" : format.pastSingular
      case -1:
        return useNumericDates ? "In \(-unitValue) \(format.singularUnit)" : format.futureSingular
      case Int.min ..< -1:
        return "In \(-unitValue) \(format.pluralUnit)"
      default:
        break
      }
    }
    
    return "Just now"
  }
}

extension Double {
  func getDateFromUTC() -> Date {
    let date = Date(timeIntervalSince1970: self)
    return date
  }
  func getDateStringFromUTC() -> String {
    let date = Date(timeIntervalSince1970: self)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return dateFormatter.string(from: date)
  }
}

extension Date {
  
  func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
    
    let calendar = Calendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let components = calendar.dateComponents(unitFlags, from: self, to: now)
    
    let formatter = DateComponentUnitFormatter()
    return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
  }
}

