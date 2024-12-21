//
//  BaseTargetType.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import UIKit
import Moya

protocol BaseTargetType: TargetType {
}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: "https://reqres.in")!
    }
    
    var headers: [String: String]? {
        var header = ["Content-Type": "application/json"]
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        header["app-device-uuid"] = "uuid"
        header["app-device-model-name"] = UIDevice.current.name
        header["app-device-os-version"] = UIDevice.current.systemVersion
        header["app-device-device-manufacturer"] = "apple"
        header["app-version"] = bundleVersion
        header["app-timezone-id"] = TimeZone.current.identifier
        return header
    }
    
    // BaseTargetType을 상속받는 각 TargetType에서 sampleData를 필수로 구현하지 않아도 되도록 디폴트값 부여
    var sampleData: Data {
        return Data()
    }
}
