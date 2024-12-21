//
//  URLSessionManager.swift
//  Practice_Alamofire
//
//  Created by 김기림 on 2022/08/12.
//

import Foundation

struct NetworkAPI {
    static let schema = "http"
    static let host = "localhost"
    static let port = 4000
    enum Path {
        static let storeDetail = "/delivery/detail"
        static let storeReviews = "/delivery/reviews"
    }
    
    func storeDetail(storeCode:Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = NetworkAPI.schema
        components.host = NetworkAPI.host
        components.port = NetworkAPI.port
        components.path = Path.storeDetail
        components.queryItems = [
            URLQueryItem(name: "storeCode", value: String(storeCode))
        ]
        
        return components
    }
    
    func storeReViews(storeCode:Int, count:Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = NetworkAPI.schema
        components.host = NetworkAPI.host
        components.port = NetworkAPI.port
        components.path = Path.storeDetail
        components.queryItems = [
            URLQueryItem(name: "storeCode", value: String(storeCode)),
            URLQueryItem(name: "count", value: String(count))
        ]
        
        return components
    }
}

class URLSessionManager {
    static let shared = URLSessionManager()
    private let session = URLSession(configuration: .default)
    private let api = NetworkAPI()
    
    private init() { }
    
    func getStoreDetail(storeCode: Int, completion: @escaping (Result<DetailStore, NetworkError>)->()) {
        guard let url = api.storeDetail(storeCode: storeCode).url else {
            completion(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.urlSessionError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(DetailStore.self, from: data)
                completion(.success(parsedData))
                return
            } catch {
                completion(.failure(.parsingError))
                return
            }
        }.resume()
    }
    
    func getStoreDetailBackGround(storeCode: Int, completion: @escaping (Result<DetailStore, NetworkError>)->()) {
        guard let url = api.storeDetail(storeCode: storeCode).url else {
            completion(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.urlSessionError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(DetailStore.self, from: data)
                completion(.success(parsedData))
                return
            } catch {
                completion(.failure(.parsingError))
                return
            }
        }.resume()
    }
    
    func getStoreDetail2(storeCode: Int, completion: @escaping (Result<DetailStore, NetworkError>)->()) {
        guard let url = api.storeDetail(storeCode: storeCode).url else {
            completion(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request)
    }
}

enum NetworkError: Error {
    case responseError
    case urlSessionError
    case noData
    case parsingError
    case badURL
}

struct DetailStore: Codable {
    var code: String
    var storeName: String
    var deliveryPrice: Int
    var minPrice: Int
    var imageUrl: String
    enum CodingKeys: String, CodingKey {
        case code, storeName, deliveryPrice, minPrice
        case imageUrl = "thumbnailUrl"
    }
}
