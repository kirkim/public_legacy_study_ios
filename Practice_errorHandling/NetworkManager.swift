//
//  Network.swift
//  Practice_errorHandling
//
//  Created by 김기림 on 2022/08/09.
//

import UIKit

final class NetworkManager2 {
    static let shared = NetworkManager2()
    private let session = URLSession.shared
    private init() { }

    func loadImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                completion(nil)
                return
            }
            guard let hasData = data,
                  let image = UIImage(data: hasData) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared
    private init() { }
    
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, CustomError>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.urlSessionError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.responseCodeError(code: httpResponse.statusCode)))
                return
            }
            guard let hasData = data,
                  let image = UIImage(data: hasData) else {
                completion(.failure(.noImageData))
                return
            }
            completion(.success(image))
        }.resume()
    }
    
//    func loadImage(urlString: String, completion: @escaping (UIImage) -> ()) throws {
//        guard let url = URL(string: urlString) else {
//            throw CustomError.badURL
//        }
//        session.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                throw CustomError.urlSessionError
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200..<300).contains(httpResponse.statusCode) else {
//                throw CustomError.responseError
//            }
//            guard let hasData = data,
//                  let image = UIImage(data: hasData) else {
//                throw CustomError.noImageData
//            }
//            completion(image)
//        }.resume()
//    }
}


