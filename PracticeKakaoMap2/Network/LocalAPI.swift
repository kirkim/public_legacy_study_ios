//
//  LocalAPI.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/12.
//

import Foundation

struct LocalAPI {
    static let schema = "https"
    static let host = "dapi.kakao.com"
    static let path1 = "/v2/local/search/category.json"
    static let path2 = "/v2/local/geo/coord2address.json"
    
    func getLocation(by mapPoint: MTMapPoint) -> URLComponents {
        var components = URLComponents()
        components.scheme = LocalAPI.schema
        components.host = LocalAPI.host
        components.path = LocalAPI.path1
        
        components.queryItems = [
            URLQueryItem(name: "category_group_code", value: "CS2"),
            URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
            URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
            URLQueryItem(name: "radius", value: "500"),
            URLQueryItem(name: "sort", value: "distance")
        ]
        
        return components
    }
    
    func getAddress(by mapPoint: MTMapPoint) -> URLComponents {
        var components = URLComponents()
        components.scheme = LocalAPI.schema
        components.host = LocalAPI.host
        components.path = LocalAPI.path2
        
        components.queryItems = [
            URLQueryItem(name: "x", value: "\(mapPoint.mapPointGeo().longitude)"),
            URLQueryItem(name: "y", value: "\(mapPoint.mapPointGeo().latitude)"),
        ]
        
        return components
    }
}

