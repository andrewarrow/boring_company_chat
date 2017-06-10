//
//  ChatService.swift
//  boring-company-chat
//
//  Created by A Arrow on 6/8/17.
//  Copyright © 2017 755R3VBZ84. All rights reserved.
//

import Foundation
import Moya

enum ChatService {
  case zen
  case showUser(id: Int)
  case createUser(firstName: String, lastName: String)
  case updateUser(id:Int, firstName: String, lastName: String)
  case showChannels(token: String)
  case showGroups(token: String)
  case showIMs(token: String)
  case showUsers(token: String)
  case showTeam(token: String)
  case historyIM(token: String, id: String)
  case historyGroup(token: String, id: String)
}

extension ChatService: TargetType {
  var baseURL: URL { return URL(string: "https://slack.com")! }
  
  var path: String {
    switch self {
    case .zen:
      return "/zen"
    case .showUser(let id), .updateUser(let id, _, _):
      return "/users/\(id)"
    case .createUser(_, _):
      return "/users"
    case .showChannels:
      return "/api/channels.list"
    case .showGroups:
      return "/api/groups.list"
    case .showIMs:
      return "/api/im.list"
    case .historyIM:
      return "/api/im.history"
    case .historyGroup:
      return "/api/groups.history"
    case .showUsers:
      return "/api/users.list"
    case .showTeam:
      return "/api/team.info"
    }
  }
  var method: Moya.Method {
    switch self {
    case .zen, .showUser, .showChannels, .showGroups, .showIMs, .showUsers,
         .showTeam, .historyIM, .historyGroup:
      return .get
    case .createUser, .updateUser:
      return .post
    }
  }
  var parameters: [String: Any]? {
    switch self {
    case .zen, .showUser:
      return nil
    case .showChannels(let token), .showGroups(let token), .showIMs(let token), .showUsers(let token), .showTeam(let token):
      return ["token": token]
    case .historyIM(let token, let id), .historyGroup(let token, let id):
      return ["token": token, "channel": id]
    case .createUser(let firstName, let lastName), .updateUser(_, let firstName, let lastName):
      return ["first_name": firstName, "last_name": lastName]
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
    case .zen, .showUser, .showChannels, .showGroups, .showIMs, .updateUser, .showUsers, .showTeam, .historyIM, .historyGroup:
      return URLEncoding.default // Send parameters in URL
    case .createUser:
      return JSONEncoding.default // Send parameters as JSON in request body
    }
  }
  var sampleData: Data {
    return "Half measures are as bad as nothing at all.".utf8Encoded
  }
  var task: Task {
    switch self {
    case .zen, .showUser, .createUser, .updateUser, .showChannels, .showGroups,
         .showIMs, .showUsers, .showTeam, .historyIM, .historyGroup:
      return .request
    }
  }
}

// MARK: - Helpers
private extension String {
  var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8Encoded: Data {
    return self.data(using: .utf8)!
  }
}
