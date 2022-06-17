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
    let navigationBarViewModel = AddressNavigationBarViewModel()
    
    // ViewModel -> View
    let popVC: Signal<Void>
    
    init() {
        popVC = navigationBarViewModel.backbuttonTapped.asSignal()
    }
}
