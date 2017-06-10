import Foundation
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

class CardApiImpl: CardApi {
  
  fileprivate let provider: RxMoyaProvider<Api>
  
  init(provider: RxMoyaProvider<Api>) {
    self.provider = provider
  }
  
  func addCard( name: String) -> Observable<Card> {
    
  }
  
  func getChannels() -> Observable<Channels> {
    return provider.request(.getChannels())
      .mapObject(Channels.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  
}
