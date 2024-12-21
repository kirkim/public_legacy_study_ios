//
//  SelectAddressTypeView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/16.
//

import UIKit
import RxSwift
import RxGesture

class SelectAddressTypeStackView: UIStackView {
    private let disposeBag = DisposeBag()
    
    private let homeItemView = SelectAddressTypeItemView("house", "우리집")
    private let officeItemView = SelectAddressTypeItemView("building.2", "회사")
    private let etcItemView = SelectAddressTypeItemView("leaf", "기타")
    
    init() {
        super.init(frame: CGRect.zero)
        
        layout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SelectAddressTypeStackViewModel) {
        homeItemView.rx.tapGesture()
            .when(.recognized)
            .map { _ in SelectAddressType.home }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)
        
        officeItemView.rx.tapGesture()
            .when(.recognized)
            .map { _ in SelectAddressType.office }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)
        
        etcItemView.rx.tapGesture()
            .when(.recognized)
            .map { _ in SelectAddressType.etc }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)
        
        viewModel.changeTypeState
            .emit(to: self.rx.changeTypeState)
            .disposed(by: disposeBag)
    }
    
    func changeState(type: SelectAddressType) {
        self.homeItemView.state(isSelected: type == .home)
        self.officeItemView.state(isSelected: type == .office)
        self.etcItemView.state(isSelected: type == .etc)
    }
    
    private func attribute() {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 5
        
    }
    
    private func layout() {
        [homeItemView, officeItemView, etcItemView].forEach {
            self.addArrangedSubview($0)
        }
    }
}

extension Reactive where Base: SelectAddressTypeStackView {
    var changeTypeState: Binder<SelectAddressType> {
        return Binder(base) { base, type in
            base.changeState(type: type)
        }
    }
}
