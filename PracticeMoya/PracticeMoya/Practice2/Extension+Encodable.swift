//
//  Extension+Encodable.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String:Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return dic as! [String : Any]
        } catch {
            return [:]
        }
    }
}
