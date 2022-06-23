//
//  SearchView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import SnapKit

class PresentAddressSearchView: UIView {
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        titleLabel.text = "🔍 지번, 도로명, 건물명으로 검색"
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 15, weight: .light)
        
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
    }
}
