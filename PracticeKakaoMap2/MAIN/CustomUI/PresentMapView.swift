//
//  PresentMapView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit

class PresentMapView: UIView {
    private let titleLabel = UILabel()
    private let chevronMark = UIImageView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        titleLabel.text = "◎ 현재 위치로 설정"
        titleLabel.textColor = .darkGray
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        chevronMark.image = UIImage(systemName: "chevron.forward")
        chevronMark.tintColor = .darkGray
    }
    
    private func layout() {
        [titleLabel, chevronMark].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
        chevronMark.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
