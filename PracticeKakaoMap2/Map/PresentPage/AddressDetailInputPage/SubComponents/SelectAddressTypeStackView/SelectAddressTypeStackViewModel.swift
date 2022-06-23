//
//  SelectAddressTypeStackViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/17.
//

import Foundation
import RxCocoa

struct SelectAddressTypeStackViewModel {
    // View -> ViewModel
    let selectedType = BehaviorRelay<SelectAddressType>(value: .home)
    
    // ViewModel -> view
    let changeTypeState: Signal<SelectAddressType>
    
    init() {
        changeTypeState = selectedType.asSignal(onErrorJustReturn: .home)
    }
}
