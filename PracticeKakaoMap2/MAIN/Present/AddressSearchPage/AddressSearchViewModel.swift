//
//  AddressSearchViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import Foundation
import RxCocoa

struct AddressSearchViewModel {
    // SubComponent ViewModel
    let navigationBarViewModel = AddressSearchNavigationBarViewModel()
    
    // ViewModel -> View
    let popView: Signal<Void>
    
    init() {
        popView = navigationBarViewModel.backbuttonTapped.asSignal()
    }
}
