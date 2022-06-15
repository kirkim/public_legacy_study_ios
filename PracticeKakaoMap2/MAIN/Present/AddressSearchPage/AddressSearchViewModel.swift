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
    let searchBarViewModel = AddressSearchBarViewModel()
    
    // ViewModel -> View
    let popView: Signal<Void>
    let cellData: Driver<[SubAddressByTextData]>
    let tableViewState: Signal<AddressSearchState>
    
    init() {
        popView = navigationBarViewModel.backbuttonTapped.asSignal()
        cellData = searchBarViewModel.data
        tableViewState = searchBarViewModel.state.asSignal(onErrorJustReturn: .nothing)
    }
}
