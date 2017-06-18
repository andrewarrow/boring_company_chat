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
  
  func rtmConnect(token: String) -> Observable<Team> {
    return provider.request(.rtmConnect(token: token))
      .mapObject(Team.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func postMessage(token: String, id: String, text: String) -> Observable<Message> {
    return provider.request(.postMessage(token: token, id: id, text: text))
      .mapObject(Message.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getHistoryByFlavor(token: String, id: String, flavor: String, count: Int) -> Observable<Messages> {
    if flavor == "im" {
      return getHistoryIM(token: token, id: id, count: count)
    } else if flavor == "groups" {
      return getHistoryGroup(token: token, id: id, count: count)
    } else if flavor == "channels" {
      return getHistoryChannel(token: token, id: id, count: count)
    }
    return getHistoryChannel(token: token, id: id, count: count)
  }
  
  func getHistoryChannel(token: String, id: String, count: Int) -> Observable<Messages> {
    return provider.request(.historyChannel(token: token, id: id, count: count))
      .mapObject(Messages.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getHistoryGroup(token: String, id: String, count: Int) -> Observable<Messages> {
    return provider.request(.historyGroup(token: token, id: id, count: count))
      .mapObject(Messages.self)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .observeOn(MainScheduler.instance)
  }
  
  func getHistoryIM(token: String, id: String, count: Int) -> Observable<Messages> {
    return provider.request(.historyIM(token: token, id: id, count: count))
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
