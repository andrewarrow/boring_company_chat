import Foundation
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

class ChannelApiImpl: ChannelApi {
  
  fileprivate let provider: RxMoyaProvider<ChatService>
  
  init(provider: RxMoyaProvider<ChatService>) {
    self.provider = provider
  }
    
  func getChannels() -> Observable<Channels> {
    return provider.request(.showChannels(token: ""))
      .mapObject(Channels.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  
}
