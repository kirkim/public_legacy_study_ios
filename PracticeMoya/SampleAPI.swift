//
//  SampleAPI.swift
//  PracticeMoya
//
//  Created by 김기림 on 2022/09/21.
//

import UIKit
import Moya

enum SampleAPI {
    case searchImage(_ page: String = "", _ keyword: String = "")
}

extension SampleAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .searchImage(image: _):
            return "/search/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchImage(_, _):
            return .get
        }
    }
    
  
    var sampleData: Data {
        switch self {
        case .searchImage(_, _):
            return Data(
                """
                {
                    "total": 1000,
                    "results": {
                        "createdAt": "2017-12-12T18:53:59Z",
                        "height": 5184,
                        "width": 3456,
                        "urls": {
                            "regular": "https://images.unsplash.com/photo-1513104890138-7c749659a591?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyODkwMjd8MHwxfHNlYXJjaHwxfHxwaXp6YXxlbnwwfHx8fDE2NjM3Mjg4MDA&ixlib=rb-1.2.1&q=80&w=1080",
                            "thumb": "https://images.unsplash.com/photo-1513104890138-7c749659a591?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyODkwMjd8MHwxfHNlYXJjaHwxfHxwaXp6YXxlbnwwfHx8fDE2NjM3Mjg4MDA&ixlib=rb-1.2.1&q=80&w=200"
                        }
                    }
                }
                """.utf8
            )
        }
    }
    
    var task: Task {
        switch self {
        case let .searchImage(page, keyword):
            let params: [String: Any] = [
                "page": page,
                "query": keyword,
                "client_id": "XEWW_uPfwublfP0Vds0M6MP1JCcgSJniF9q38N8FyL4"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
