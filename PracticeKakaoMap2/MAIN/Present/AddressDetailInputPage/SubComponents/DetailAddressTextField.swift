//
//  DetailAddressTextField.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/16.
//

import UIKit
import SnapKit

class DetailAddressTextField: UIView {
    private let fakeBorderView = UIView()
    private let textField = UITextField()
    private let dynamicLabel = UILabel()
    private var point: (CGFloat, CGFloat)?
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        fakeBorderView.layer.cornerRadius = 5
        fakeBorderView.layer.borderWidth = 1

        textField.delegate = self
//        textField.placeholder = "예) 기림아파트 101동 101호"
        
        dynamicLabel.text = " 상세 주소 입력 "
        dynamicLabel.textColor = .darkGray
        dynamicLabel.font = .systemFont(ofSize: 16)
        dynamicLabel.backgroundColor = .white
    }
    
    private func layout() {
        [fakeBorderView, textField, dynamicLabel].forEach {
            self.addSubview($0)
        }
        
        fakeBorderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        dynamicLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}

extension DetailAddressTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = ""
        fakeBorderView.layer.borderWidth = 1
        fakeBorderView.layer.borderColor = UIColor.darkGray.cgColor
        if (textField.text == "") {
            UIView.animate(withDuration: 0.3, delay: 0) {
                textField.placeholder = ""
                self.dynamicLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.dynamicLabel.frame.origin.x = self.point!.0
                self.dynamicLabel.frame.origin.y = self.point!.1
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        fakeBorderView.layer.borderWidth = 2
        fakeBorderView.layer.borderColor = UIColor.black.cgColor
        if (self.point == nil) {
            self.point = (self.dynamicLabel.frame.origin.x, self.dynamicLabel.frame.origin.y)
        }
        if (textField.text == "") {
            UIView.animate(withDuration: 0.3, delay: 0) {
                textField.placeholder = "예) 기림아파트 101동 101호"
                self.dynamicLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.dynamicLabel.frame.origin.x = 10
                self.dynamicLabel.frame.origin.y = -6
            }
        }
    }
}
