//
//  PresentMapView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import SnapKit

enum PresentMapType {
    case currentPoint
    case targetPoint
}

class PresentMapView: UIView {
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronMark = UIImageView()
    private let mapType: PresentMapType
    
    init(_ mapType: PresentMapType) {
        self.mapType = mapType
        super.init(frame: CGRect.zero)
        
        setType()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setType() {
        switch self.mapType {
        case .currentPoint:
            logoImageView.image = UIImage(systemName: "pin")
            titleLabel.text = "현재 위치로 설정"
        case .targetPoint:
            logoImageView.image = UIImage(systemName: "map")
            titleLabel.text = "지도에서 위치 확인"
        }
    }
    
    private func attribute() {
        titleLabel.textColor = .darkGray
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        chevronMark.image = UIImage(systemName: "chevron.forward")
        chevronMark.tintColor = .darkGray
        
        logoImageView.tintColor = .darkGray
    }
    
    private func layout() {
        [logoImageView, titleLabel, chevronMark].forEach {
            addSubview($0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        chevronMark.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
