import Foundation
import ObjectMapper

struct Users: Mappable {
  
  var results: Array<User>?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    results <- map["members"]
  }
}

struct User: Mappable, Equatable {
  
  var id: String?
  var name: String?
  var image48: String?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    image48 <- map["profile.image_48"]
  }
  
  func briefDescription() -> String {
    return name!
  }
  
  static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
  }
  
}
