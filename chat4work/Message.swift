import Foundation
import ObjectMapper
import RealmSwift

class MessageObject: Object {
  dynamic var id = ""
  dynamic var text = ""
  dynamic var channel = ""
  dynamic var ts = ""
  dynamic var tsd = Double(0.0)
  dynamic var user = ""
  dynamic var username = ""
  dynamic var team = ""
  
  override class func primaryKey() -> String? { return "id" }
}

struct Messages: Mappable {
  
  var results: Array<Message>?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    results <- map["messages"]
  }
}

struct Message: Mappable, Equatable {
  
  var type: String?
  var ts: String?
  var user: String?
  var text: String?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    type <- map["type"]
    ts <- map["ts"]
    user <- map["user"]
    text <- map["text"]
  }
  
  func briefDescription() -> String {
    return user!
  }
  
  static func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.ts == rhs.ts
  }
  
}
