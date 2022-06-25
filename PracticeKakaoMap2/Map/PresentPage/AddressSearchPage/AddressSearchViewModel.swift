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
    let searchBarViewModel = AddressSearchBarViewModel()
    
    // ViewModel -> View
    let cellData: Driver<[SubAddressByTextData]>
    let tableViewState: Signal<AddressSearchState>
    
    // View -> ViewModel
    let itemSeleted = PublishRelay<Int>()
    
    init() {
        cellData = searchBarViewModel.data
        tableViewState = searchBarViewModel.state.asSignal(onErrorJustReturn: .nothing)
    }
}
