//
//  AddressSearchNavigationBarView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit

class AddressNavigationBar: UIView {
    private let disposeBag = DisposeBag()
    
    private let backButtonLabel = UILabel()
    private let titleLabel = UILabel()
    
    var rootViewController: UIViewController?
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        self.titleLabel.text = title
        attribute()
        layout()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        backButtonLabel.rx.tapGesture()
            .when(.recognized)
            .map { _ in return }
            .subscribe(onNext: { [weak self] in
                self?.rootViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        backButtonLabel.text = "←"
        backButtonLabel.font = .systemFont(ofSize: 22, weight: .bold)
        backButtonLabel.textColor = .black
    }
    
    private func layout() {
        [backButtonLabel, titleLabel].forEach {
            self.addSubview($0)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        backButtonLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(10)
        }
    }
}
