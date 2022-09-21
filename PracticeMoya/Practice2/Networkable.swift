//
//  Networkable.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import Foundation
import Moya

protocol Networkable {
    associatedtype Target: TargetType
    static func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {
    
    static func makeProvider() -> MoyaProvider<Target> {
        /// access token 세팅
        let authPlugin = AccessTokenPlugin { _ in
            return "bear-access-token-sample"
        }
        
        /// 로그 세팅
        let loggerPlugin = NetworkLoggerPlugin()
        
        /// plugin객체를 주입하여 provider 객체 생성
        return MoyaProvider<Target>(plugins: [authPlugin, loggerPlugin])
    }
}
