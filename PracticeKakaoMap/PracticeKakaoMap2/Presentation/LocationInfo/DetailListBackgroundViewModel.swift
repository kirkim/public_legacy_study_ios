//
//  DetailListBackgroundViewModel.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/12.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    // ViewModel -> View
    let isStatusLabelHidden: Signal<Bool>
    
    //외부에서 전달받을 값
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
