//
//  DeliveryMapViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import Foundation
import RxCocoa
import RxSwift

struct DeliveryMapViewModel {
    let disposeBag = DisposeBag()
    
    // SubComponents ViewModel
    let mapInfoViewModel = MapInfoViewModel()
    
    //View -> ViewModel
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let currentLocation = PublishRelay<MTMapPoint>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let initSetMapCenter = PublishRelay<Void>()
    
    //ViewModel -> View
    let setMapCenter: Signal<MTMapPoint>
    
    init(model: DeliveryMapModel = DeliveryMapModel()){
        mapCenterPoint.bind(to: model.mapCenterPoint).disposed(by: disposeBag)
        
        model.documentData
            .share()
            .map { $0[0] }
            .bind(to: mapInfoViewModel.data)
            .disposed(by: disposeBag)
        
//        let moveMapCenter = Observable.combineLatest(currentLocationButtonTapped, initSetMapCenter, currentLocation) { $2 }
        let moveMapCenter = Observable.merge(
            currentLocationButtonTapped.withLatestFrom(currentLocation),
            initSetMapCenter.withLatestFrom(currentLocation)
        )
//        let moveMapCenter2 = Observable.combineLatest(moveMapCenter, currentLocation) { $1 }
        
        setMapCenter = moveMapCenter.asSignal(onErrorSignalWith: .empty())
        moveMapCenter.subscribe(onNext: { value in
            print(value)
        })
        .disposed(by: disposeBag)
    }
}
