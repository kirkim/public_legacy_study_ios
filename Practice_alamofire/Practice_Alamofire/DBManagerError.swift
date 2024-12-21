//
//  DBManagerError.swift
//  Practice_Alamofire
//
//  Created by 김기림 on 2022/08/13.
//

import Foundation

enum DBManagerError: Error {
    case badURL
    case failToSaveImageFile
    case failToSaveImageInfo
    case responseError
    case failParsingToImage
    case failToRemoveImageFile
    case failToRemoveImageInfo
    
    var description: String {
        switch self {
        case .badURL:
            return "잘못된 url주소입니다."
        case .failToSaveImageFile:
            return "이미지파일 저장에 실패했습니다."
        case .failToSaveImageInfo:
            return "이미지정보 저장에 실패했습니다."
        case .responseError:
            return "네트워크 에러"
        case .failParsingToImage:
            return "image로 파싱이 실패했습니다."
        case .failToRemoveImageFile:
            return "이미지파일 삭제에 실패했습니다."
        case .failToRemoveImageInfo:
            return "이미지정보 삭제에 실패했습니다."
        }
    }
}
