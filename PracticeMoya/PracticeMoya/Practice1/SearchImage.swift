//
//  SearchImage.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import Foundation

struct SearchImage: Decodable {
    var total: Int
    var results: [Images]
    
    struct Images: Decodable {
        var createdAt: String
        var width: Int
        var height: Int
        var urls: URLS
        
        enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case width, height, urls
        }
        
        struct URLS: Decodable {
            var regular: String
            var thumb: String
        }
    }
}
