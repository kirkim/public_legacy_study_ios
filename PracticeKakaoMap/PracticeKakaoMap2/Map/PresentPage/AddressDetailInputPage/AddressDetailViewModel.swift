//
//  AddressDetailViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/17.
//

import Foundation
import RxCocoa

struct AddressDetailViewModel {
    // child ViewModel
    let selectAddressTypeViewmodel = SelectAddressTypeStackViewModel()
    let deliveryMapViewModel = DeliveryMapViewModel()
    
    // View -> ViewModel
    let presentMapButtonViewTapped = PublishRelay<Void>()
    let dataObserver:BehaviorRelay<SubAddressByTextData>
    
    // ViewModel -> View
    let presentMapView: Signal<MTMapPoint?>
    
    // ChildViewModel -> ViewModel
    
    init(_ data: SubAddressByTextData) {
        dataObserver = BehaviorRelay<SubAddressByTextData>(value: data)
        
        presentMapView = dataObserver
            .map { data in
                let doubleLatitude: Double = Double(data.y) ?? 0.0
                let doubleLongitude: Double = Double(data.x) ?? 0.0
                let targetPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: doubleLatitude, longitude: doubleLongitude))
                return targetPoint
            }
            .asSignal(onErrorJustReturn: nil)
    }
}
