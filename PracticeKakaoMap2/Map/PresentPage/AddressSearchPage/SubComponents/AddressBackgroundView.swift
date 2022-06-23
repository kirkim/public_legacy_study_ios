//
//  AddressBackgroundView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit

class AddressBackgroundView: UIView {
    
    private let containerStackView = UIStackView()
    private let mainLabel = UILabel()
    private let subLabel1 = UILabel()
    private let subLabel2 = UILabel()
    private let subLabel3 = UILabel()
    
    private let iconImageView = UIImageView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        
        mainLabel.numberOfLines = 1
        mainLabel.text = "이렇게 검색해 보세요"
        
        [subLabel1, subLabel2, subLabel3].forEach {
            $0.numberOfLines = 2
            $0.textColor = .systemGray
            $0.font = .systemFont(ofSize: 15, weight: .light)
        }
        subLabel1.text = "∙도로명 + 건물번호\n  예)기림로 12길 3"
        subLabel2.text = "∙지역명 + 번지\n  예) 기림동 12-3"
        subLabel3.text = "∙건물명, 아파트명\n  예) 기림아파트 101동"
        
        iconImageView.image = UIImage(named: "mapIcon")
    }
    
    private func layout() {
        [mainLabel, subLabel1, subLabel2, subLabel3].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [containerStackView, iconImageView].forEach {
            self.addSubview($0)
        }
        
        containerStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.height.equalTo(160)
        }
        
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.top.trailing.equalToSuperview()
        }
    }
}
