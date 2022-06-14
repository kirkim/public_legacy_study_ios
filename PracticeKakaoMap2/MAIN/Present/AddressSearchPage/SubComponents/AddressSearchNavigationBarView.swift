//
//  AddressSearchNavigationBarView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import SnapKit

class AddressSearchNavigationBarView: UIView {
    private let disposeBag = DisposeBag()
    
    private let backButton = UIImageView()
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: AddressSearchNavigationBarViewModel) {
        backButton.rx.tapGesture()
            .when(.recognized)
            .map { _ in return }
            .bind(to: viewModel.backbuttonTapped)
            .disposed(by: disposeBag)
            
    }
    
    private func attribute() {
        titleLabel.text = "주소 검색"
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        backButton.image = UIImage(systemName: "arrow.left")
        backButton.tintColor = .black
    }
    
    private func layout() {
        [backButton, titleLabel].forEach {
            self.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
