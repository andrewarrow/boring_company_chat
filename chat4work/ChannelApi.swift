import Foundation
import RxSwift

enum ChannelApiError: Error {
  case invalidCode
}

protocol ChannelApi {
    
  func getChannels(token: String) -> Observable<Channels>

}
