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
  
  func getHistoryIM(token: String, id: String) -> Observable<Messages> {
    return provider.request(.historyIM(token: token, id: id))
      .mapObject(Messages.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getUsers(token: String) -> Observable<Users> {
    return provider.request(.showUsers(token: token))
      .mapObject(Users.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getIMs(token: String) -> Observable<Ims> {
    return provider.request(.showIMs(token: token))
      .mapObject(Ims.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getGroups(token: String) -> Observable<Groups> {
    return provider.request(.showGroups(token: token))
      .mapObject(Groups.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
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
