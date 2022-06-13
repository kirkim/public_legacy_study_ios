//
//  MapInfoView.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift

class MapInfoView: UIView {
    private let disposeBag = DisposeBag()
    
    private let addressLabel = UILabel()
    private let switchButton = MapInfoSwithLabel()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MapInfoViewModel) {
        viewModel.addressName
            .emit(to: self.addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        switchButton.rx.tapGesture()
            .when(.recognized)
            .bind(to: viewModel.tapSwitchButton)
            .disposed(by: disposeBag)
            
        viewModel.addressType.share()
            .bind { [weak self] type in
                switch type {
                case .basic:
                    self?.switchButton.text = "♺ 도로명으로 보기"
                case .road:
                    self?.switchButton.text = "♺ 지번으로 보기"
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        addressLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        switchButton.backgroundColor = .systemGray4
        switchButton.font = .systemFont(ofSize: 13, weight: .medium)
        switchButton.layer.cornerRadius = 16
        switchButton.layer.masksToBounds = true
    }
    
    private func layout() {
        [addressLabel, switchButton].forEach {
            addSubview($0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        switchButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
    }
}

class MapInfoSwithLabel: UILabel {
    private var padding = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}

