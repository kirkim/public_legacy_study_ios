//
//  ListUserTarget.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import Foundation
import Moya

enum ListUserTarget {
    case list(ListUserRequest)
}

extension ListUserTarget: BaseTargetType {
    
    var path: String {
        switch self {
        case .list: return "/api/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .list(let request): return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
}

extension ListUserTarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
