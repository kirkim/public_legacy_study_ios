//
//  UrlSessionManager.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/21.
//

import Foundation
import Alamofire

// UrlSession Timeout Manager
class UrlSessionManager: Alamofire.Session {
  static let sharedManager: UrlSessionManager = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 300
    configuration.timeoutIntervalForResource = 300
    configuration.requestCachePolicy = .useProtocolCachePolicy
    return UrlSessionManager(configuration: configuration)
  }()
}
