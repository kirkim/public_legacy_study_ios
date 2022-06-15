//
//  AddressByTextData.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/15.
//

import Foundation

struct AddressByTextData: Codable {
    var documents: [SubAddressByTextData]
}

struct SubAddressByTextData: Codable {
    var address: BasicAddress?
    var road_address: LoadAddress?
    var address_name: String
    var x: String
    var y: String
}

struct BasicAddress: Codable {
    var address_name: String
}

struct LoadAddress: Codable {
    var address_name:String
    var building_name: String
}
