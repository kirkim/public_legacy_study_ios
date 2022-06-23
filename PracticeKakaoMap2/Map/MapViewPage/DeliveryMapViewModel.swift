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
    
    init(model: DeliveryMapModel = DeliveryMapModel()){
        mapCenterPoint.bind(to: model.mapCenterPoint).disposed(by: disposeBag)
        
        model.documentData
            .share()
            .map { $0[0] }
            .bind(to: mapInfoViewModel.data)
            .disposed(by: disposeBag)
    }
}
