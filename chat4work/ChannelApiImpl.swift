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
    
  func getChannels(token: String) -> Observable<Channels> {
    return provider.request(.showChannels(token: token))
      .mapObject(Channels.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getTeamInfo(token: String) -> Observable<Team> {
    return provider.request(.showTeam(token: token))
      .mapObject(Team.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  
}
