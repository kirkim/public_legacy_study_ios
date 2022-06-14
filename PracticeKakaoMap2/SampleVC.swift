//
//  SampleVC.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SampleVC: UIViewController {
    private let disposeBag = DisposeBag()
    private let btn = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.btn.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let vc = AddressPageViewController()
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.view.backgroundColor = .white
        btn.setTitle(" 열기 ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
    }
    
    private func layout() {
        [btn].forEach {
            view.addSubview($0)
        }
        
        btn.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
