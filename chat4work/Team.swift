import Foundation
import ObjectMapper

struct Teams: Mappable {
  
  var results: Array<Team>?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    results <- map["teams"]
  }
}

struct Team: Mappable, Equatable {
  
  var id: String?
  var name: String?
  var domain: String?
  var email_domain: String?
  var icon: String?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    domain <- map["domain"]
    email_domain <- map["email_domain"]
    icon <- map["icon"]["image_44"]
  }
  
  func briefDescription() -> String {
    return name!
  }
  
  static func ==(lhs: Team, rhs: Team) -> Bool {
    return lhs.id == rhs.id
  }
  
}
