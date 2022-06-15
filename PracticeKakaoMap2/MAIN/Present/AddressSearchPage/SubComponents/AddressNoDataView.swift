//
//  AddressNoDataView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/15.
//

import UIKit

class AddressNoDataView: UIView {
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
        self.titleLabel.text = "검색결과가 없습니다.\n도로명, 지번, 건물명, 아파트명으로\n다시 검색해주세요."
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 3
    }
    
    private func layout() {
        [titleLabel].forEach {
            self.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.center.equalToSuperview()
        }
    }
}
