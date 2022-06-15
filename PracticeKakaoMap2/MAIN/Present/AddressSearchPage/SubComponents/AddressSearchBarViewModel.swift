//
//  AddressSearchBarViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/15.
//

import Foundation
import RxCocoa
import RxSwift

struct AddressSearchBarViewModel {
    private let disposeBag = DisposeBag()
    private let network = LocalNetwork()
    
    // View -> ViewModel
    let submitText = PublishRelay<String>()
    
    // ViewModel -> ParentViewModel
    let data: Driver<[SubAddressByTextData]>
    let state = BehaviorRelay<AddressSearchState>(value: .nothing)
    
    init () {
        let dataBundle = submitText.flatMapLatest(network.getAddressByText)
            .map { result -> AddressByTextData? in
                guard case let .success(value) = result else {
                    return nil
                }
                return value
            }
            .filter { $0 != nil }
            .map { $0!.documents }
            .share()
        
        dataBundle.map { data-> AddressSearchState in
            if data.isEmpty {
                return .noData
            } else {
                return .find
            }
        }
        .bind(to: state)
        .disposed(by: disposeBag)
        
        data = dataBundle
            .asDriver(onErrorJustReturn: [])
    }
}
