//
//  DetailAddressLabelView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/17.
//

import UIKit
import SnapKit

class DetailAddressLabelView: UIView {
    private let mainLabel = UILabel()
    
    init(_ data: SubAddressByTextData) {
        super.init(frame: CGRect.zero)
        
        mainLabel.text = data.address_name
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        mainLabel.font = .systemFont(ofSize: 22, weight: .medium)
    }
    
    private func layout() {
        [mainLabel].forEach {
            addSubview($0)
        }
        
        mainLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
