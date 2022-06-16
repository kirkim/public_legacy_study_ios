//
//  SelectAddressTypeView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/16.
//

import UIKit

class SelectAddressTypeStackView: UIStackView {
    private let homeItemView = SelectAddressTypeItemView("house", "우리집")
    private let officeItemView = SelectAddressTypeItemView("building.2", "회사")
    private let etcItemView = SelectAddressTypeItemView("leaf", "기타")
    
    init() {
        super.init(frame: CGRect.zero)
        
        layout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 5
        
    }
    
    private func layout() {
        [homeItemView, officeItemView, etcItemView].forEach {
            self.addArrangedSubview($0)
        }
    }
}
