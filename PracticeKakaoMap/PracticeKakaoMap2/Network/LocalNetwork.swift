//
//  LocalNetwork.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/12.
//

import RxSwift

class LocalNetwork {
    private let session: URLSession
    let api = LocalAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        guard let url = api.getLocation(by: mapPoint).url else {
            return .just(.failure(URLError(.badURL)))
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK bec7ecd230f47f4a5bc1c6dc80c64c3a", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData)
                } catch {
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { _ in .just(Result.failure(URLError(.cannotLoadFromNetwork)))}
            .asSingle()
    }
    
    func getAddressByPoint(by mapPoint: MTMapPoint) -> Single<Result<AddressData, URLError>> {
        guard let url = api.getAddressByPoint(by: mapPoint).url else {
            return .just(.failure(URLError(.badURL)))
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK bec7ecd230f47f4a5bc1c6dc80c64c3a", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let addressData = try JSONDecoder().decode(AddressData.self, from: data)
                    return .success(addressData)
                } catch {
                    print("decodeERROR!!")
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { _ in
                print("failLoad!!")
                return .just(Result.failure(URLError(.cannotLoadFromNetwork)))
            }
            .asSingle()
    }
    
    func getAddressByText(by text: String) -> Single<Result<AddressByTextData, URLError>> {
        let url = api.getAddress(by: text)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("KakaoAK bec7ecd230f47f4a5bc1c6dc80c64c3a", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let addressData = try JSONDecoder().decode(AddressByTextData.self, from: data)
                    return .success(addressData)
                } catch {
                    print("decoding error")
                    print(error)
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { error in
                print(error)
                return .just(Result.failure(URLError(.cannotLoadFromNetwork)))
            }
            .asSingle()
    }
    
}
