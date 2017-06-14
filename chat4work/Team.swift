import Foundation
import ObjectMapper

struct Team: Mappable {
  
  var id: String?
  var name: String?
  var domain: String?
  var email_domain: String?
  var icon: String?
  var token: String?
  var url: String?  // used in rtm
  
  init?(map: Map) {
  }

  init?(withToken: String, id: String) {
    token = withToken
    self.id = id
  }

  mutating func mapping(map: Map) {
    
    id <- map["team.id"]
    name <- map["team.name"]
    domain <- map["team.domain"]
    email_domain <- map["team.email_domain"]
    icon <- map["team.icon.image_44"]
    url <- map["url"]
  }
  
  func briefDescription() -> String {
    return name!
  }

}
