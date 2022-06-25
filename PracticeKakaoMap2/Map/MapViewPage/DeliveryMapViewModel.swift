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
    // Model
    private let model = DeliveryMapModel()
    
    // SubComponents ViewModel
    let mapInfoViewModel = MapInfoViewModel()
    
    // View -> ViewModel
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let currentLocation = PublishRelay<MTMapPoint>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let initSetMapCenter = PublishRelay<Void>()
    
    // ViewModel -> View
    let setMapCenter: Signal<MTMapPoint>
    
    // ViewModel -> ParentViewModel
    
    
    init(){
        mapCenterPoint.bind(to: model.mapCenterPoint).disposed(by: disposeBag)
        
        model.documentData
            .share()
            .map { $0[0] }
            .bind(to: mapInfoViewModel.data)
            .disposed(by: disposeBag)
        
        let moveMapCenter = Observable.merge(
            currentLocationButtonTapped.withLatestFrom(currentLocation),
            initSetMapCenter.withLatestFrom(currentLocation)
        )
        
        setMapCenter = moveMapCenter.asSignal(onErrorSignalWith: .empty())
    }
}
