import Foundation
import ObjectMapper

struct Groups: Mappable {
  
  var results: Array<Group>?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    results <- map["groups"]
  }
}

struct Group: Mappable, Equatable {
  
  var id: String?
  var name: String?
  var creator: String?
  var created: Int64?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    creator <- map["creator"]
    created <- map["created"]
  }
  
  func briefDescription() -> String {
    return name!
  }
  
  static func ==(lhs: Group, rhs: Group) -> Bool {
    return lhs.id == rhs.id
  }
  
}
