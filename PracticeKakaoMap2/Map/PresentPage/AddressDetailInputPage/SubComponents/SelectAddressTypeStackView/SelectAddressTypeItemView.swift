//
//  SelectAddressTypeSubView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/16.
//

import UIKit
import SnapKit

class SelectAddressTypeItemView: UIView {
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    
    init(_ logoImageName: String, _ title: String) {
        super.init(frame: CGRect.zero)
        
        logoImageView.image = UIImage(systemName: logoImageName) ?? UIImage(systemName: "leaf")
        titleLabel.text = title
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func state(isSelected: Bool) {
        if (isSelected == true) {
            self.layer.borderColor = UIColor.systemBrown.cgColor
            self.logoImageView.tintColor = .systemBrown
            self.titleLabel.textColor = .systemBrown
            self.backgroundColor = .systemBrown.withAlphaComponent(0.3)
        } else {
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.logoImageView.tintColor = .black
            self.titleLabel.textColor = .darkGray
            self.backgroundColor = .clear
        }
    }
    
    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.logoImageView.tintColor = .black
        self.titleLabel.textColor = .darkGray

        self.layer.cornerRadius = 5
        
        //temp
        self.backgroundColor = .white
    }
    
    private func layout() {
        [logoImageView, titleLabel].forEach {
            addSubview($0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(5)
        }
    }
}
