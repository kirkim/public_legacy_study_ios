//
//  ServiceError.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import Foundation
import Moya

enum ServiceError: Error {
    case MoyaError(MoyaError)
    case invalidResponse(responseCode: Int, message: String)
    case tokenExpired
    case refreshTokenExpired
    case duplicateLoggedIn(message: String)
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .MoyaError(moyaError):
            return moyaError.localizedDescription
        case let .invalidResponse(_, message):
            return message
        case .tokenExpired:
            return "AccessToken Expired"
        case .refreshTokenExpired:
            return "RefreshToken Expired"
        case let .duplicateLoggedIn(message):
            return message
        }
    }
}
