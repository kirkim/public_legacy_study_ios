//
//  CustomError.swift
//  Practice_errorHandling
//
//  Created by 김기림 on 2022/08/09.
//

import Foundation

enum CustomError: Error {
    case badURL
    case urlSessionError
    case responseError
    case responseCodeError(code: Int)
    case noImageData
    
    var description:String {
        switch self {
        case .badURL:
            return "잘못된 URL주소입니다."
        case .urlSessionError:
            return "URLSession 에러입니다."
        case .responseError:
            return "리스폰스에러입니다."
        case .responseCodeError(code: let code):
            return "리스폰스코드에러 응답코드:\(code)"
        case .noImageData:
            return "이미지데이터를 받는데 실패했습니다."
        }
    }
}
