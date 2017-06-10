import Foundation
import ObjectMapper

struct Team: Mappable {
  
  var id: String?
  var name: String?
  var domain: String?
  var email_domain: String?
  var icon: String?
  var token: String?
  
  init?(map: Map) {
  }

  init?(withToken: String) {
    token = withToken
  }

  mutating func mapping(map: Map) {
    
    id <- map["team.id"]
    name <- map["team.name"]
    domain <- map["team.domain"]
    email_domain <- map["team.email_domain"]
    icon <- map["team.icon.image_44"]
  }
  
  func briefDescription() -> String {
    return name!
  }

}
