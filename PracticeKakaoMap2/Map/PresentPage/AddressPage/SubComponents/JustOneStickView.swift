//
//  JustOneStick.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import SnapKit

class JustOneStickView: UIView {
    private let stickView = UIView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.backgroundColor = .white
        
        stickView.backgroundColor = .systemGray3
        stickView.layer.cornerRadius = 1.5
    }
    
    private func layout() {
        self.addSubview(stickView)
        
        stickView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
            $0.width.equalTo(40)
        }
    }
}
