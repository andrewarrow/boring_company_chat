import Foundation
import ObjectMapper

struct Channels: Mappable {
  
  var results: Array<Card>?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    results <- map["channels"]
  }
}

struct Channel: Mappable, Equatable {
  
  var id: String?
  var name: String?
  var creator: String?
  var num_members: Int?
  var created: Int64?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    creator <- map["creator"]
    num_members <- map["num_members"]
    created <- map["created"]
  }
  
  func briefDescription() -> String {
    return name
  }
  
  static func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.id == rhs.id
  }
  
}
