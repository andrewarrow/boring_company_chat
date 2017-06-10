import Foundation
import RxSwift

enum ChannelApiError: Error {
  case invalidCode
}

protocol ChannelApi {
  
  func addChannel(name: String) -> Observable<Channel>
  
  func getChannels() -> Observable<Channels>

}
