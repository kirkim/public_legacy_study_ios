//
//  ExtensionReactive+MTMapView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/23.
//

import RxCocoa
import RxSwift

extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}
