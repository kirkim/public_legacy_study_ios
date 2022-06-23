//
//  MapInfoViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import Foundation
import RxCocoa
import RxGesture
import RxSwift

class MapInfoViewModel {
    private let disposeBag = DisposeBag()
    
    // View -> ViewModel
    let tapSwitchButton = PublishRelay<UITapGestureRecognizer>()
    
    // ParentViewModel -> ViewModel
    let data = PublishRelay<AdDocument>()
    
    // ViewModel -> View
    let addressName: Signal<String>
    
    let addressType = BehaviorRelay<AddressType>(value: .basic)
    
    init() {
        addressName = Observable.combineLatest(data, addressType.share()) { return $1 == .basic ? $0.address.address : $0.road_address.address }
            .asSignal(onErrorJustReturn: "")
        
        tapSwitchButton.bind { [weak self] _ in
            if self?.addressType.value == .basic {
                self?.addressType.accept(.road)
            } else {
                self?.addressType.accept(.basic)
            }
        }
        .disposed(by: disposeBag)
    }
}
