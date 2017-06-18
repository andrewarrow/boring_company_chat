import Foundation
import ObjectMapper
import RealmSwift

class ChannelList: Object {
  dynamic var team = ""
  let list = List<ChannelObject>()
}

class ChannelObject: Object {
  dynamic var name = ""
  dynamic var id = ""
  dynamic var flavor = ""
  dynamic var ts = Double(0.0)
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
