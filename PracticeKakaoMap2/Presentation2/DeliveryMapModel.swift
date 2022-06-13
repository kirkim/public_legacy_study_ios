//
//  DeliveryMapModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import Foundation
import RxSwift
import RxCocoa

struct DeliveryMapModel {
    private let disposeBag = DisposeBag()
    var localNetwork: LocalNetwork
    
    // View -> ViewModel -> Model
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    
    // Model -> viewModel
    let documentData = PublishSubject<[AdDocument]>()
    
    init(localNetwork: LocalNetwork = LocalNetwork()) {
        self.localNetwork = localNetwork
        
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(getAddress)
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap { data -> AddressData? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
       
        cvsLocationDataValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: disposeBag)
    }
    
    func getAddress(by mapPoint: MTMapPoint) -> Single<Result<AddressData, URLError>> {
        return localNetwork.getAdress(by: mapPoint)
    }
}
