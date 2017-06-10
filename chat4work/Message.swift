import Foundation
import ObjectMapper

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
