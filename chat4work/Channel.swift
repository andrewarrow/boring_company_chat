import Foundation
import ObjectMapper
import RealmSwift

class ChannelObjectList: Object {
  dynamic var team = ""
  let list = List<ChannelObject>()
}

class ChannelObject: Object {
  dynamic var name = ""
  dynamic var id = ""
  dynamic var flavor = ""
  dynamic var ts = Double(0.0)
  dynamic var possibly_new = 0
  dynamic var mute = 0
  
  func find_name(user: String, team: String) -> String {
    let realm = try! Realm()
    // https://github.com/realm/realm-cocoa/issues/3241
    // var uol = realm.objects(UserObjectList.self).filter("team = %@ and list.id = %@", team, user).first
    
    let uol = realm.objects(UserObjectList.self).filter("team = %@", team).first
    
    for u in (uol?.list)! {
      if u.id == user {
        return u.name
      }
    }
    
    return "?"
  }
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
