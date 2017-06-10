import Foundation
import ObjectMapper

struct Ims: Mappable {
  
  var results: Array<Im>?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    results <- map["ims"]
  }
}

struct Im: Mappable, Equatable {
  
  var id: String?
  var user: String?
  var created: Int64?
  
  init?(map: Map) {
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    user <- map["user"]
    created <- map["created"]
  }
  
  func briefDescription() -> String {
    return user!
  }
  
  static func ==(lhs: Im, rhs: Im) -> Bool {
    return lhs.id == rhs.id
  }
  
}
