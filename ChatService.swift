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
  case showAccounts(token: String)
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
    case .showAccounts:
      return "/api/channels.list"
    }
  }
  var method: Moya.Method {
    switch self {
    case .zen, .showUser, .showAccounts:
      return .get
    case .createUser, .updateUser:
      return .post
    }
  }
  var parameters: [String: Any]? {
    switch self {
    case .zen, .showUser:
      return nil
    case .showAccounts(let token):
      return ["token": token]
    case .createUser(let firstName, let lastName), .updateUser(_, let firstName, let lastName):
      return ["first_name": firstName, "last_name": lastName]
    }
  }
  
  var parameterEncoding: ParameterEncoding {
    switch self {
    case .zen, .showUser, .showAccounts, .updateUser:
      return URLEncoding.default // Send parameters in URL
    case .createUser:
      return JSONEncoding.default // Send parameters as JSON in request body
    }
  }
  var sampleData: Data {
    switch self {
    case .zen:
      return "Half measures are as bad as nothing at all.".utf8Encoded
    case .showUser(let id):
      return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
    case .createUser(let firstName, let lastName):
      return "{\"id\": 100, \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
    case .updateUser(let id, let firstName, let lastName):
      return "{\"id\": \(id), \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
    case .showAccounts:
      return "{\"id\":\"123\"}".utf8Encoded
    }
  }
  var task: Task {
    switch self {
    case .zen, .showUser, .createUser, .updateUser, .showAccounts:
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
