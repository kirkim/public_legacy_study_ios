//
//  AdDocuments.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import Foundation

struct AdDocument: Decodable {
    var road_address: SubAdDocument
    var address: SubAdDocument
}

struct SubAdDocument: Decodable {
    var address: String
    var address_depth1: String
    var address_depth2: String
    var address_depth3: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case address_depth1 = "region_1depth_name"
        case address_depth2 = "region_2depth_name"
        case address_depth3 = "region_3depth_name"
    }
}
