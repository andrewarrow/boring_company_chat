import Foundation
import ObjectMapper
import RealmSwift

class ChannelObject: Object {
  dynamic var team = ""
  dynamic var name = ""
  dynamic var id = ""
  dynamic var pkey = ""
  dynamic var flavor = ""
  dynamic var ts = Double(0.0)
  dynamic var possibly_new = 0
  dynamic var mute = 0
  
  override class func primaryKey() -> String? { return "pkey" }
}

struct Channels: Mappable {
  
  var results: Array<Channel>?
  
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
    return name!
  }
  
  static func ==(lhs: Channel, rhs: Channel) -> Bool {
    return lhs.id == rhs.id
  }
  
}
