//
//  AddressPageViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import UIKit
import SnapKit
import RxGesture
import RxSwift

class AddressPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let containerStackView = UIStackView()
    private let stickView = JustOneStickView()
    private let titleLabel = UILabel()
    private let presentSearchViewButton = PresentAddressSearchView()
    private let presentMapViewButton = PresentMapView(.currentPoint)
    
    private let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.presentSearchViewButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                let vc = AddressSearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    private func attribute() {
        view.backgroundColor = .systemGray
        
        titleLabel.text = "주소 설정"
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.textAlignment = .center
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
        containerStackView.backgroundColor = .white
        
        // temp
        tableView.backgroundColor = .brown
    }
    
    private func layout() {
        [stickView, titleLabel, presentSearchViewButton, presentMapViewButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        let stickViewHeight = 25
        let titleLabelHeight = 40
        let searchViewHeight = 40
        let presentMapViewHeight = 50
        let containerHeight = stickViewHeight + titleLabelHeight + searchViewHeight + presentMapViewHeight
        
        stickView.snp.makeConstraints {
            $0.height.equalTo(stickViewHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(titleLabelHeight)
        }
        
        presentSearchViewButton.snp.makeConstraints {
            $0.height.equalTo(searchViewHeight)
        }
        
        presentMapViewButton.snp.makeConstraints {
            $0.height.equalTo(presentMapViewHeight)
        }
        
        [containerStackView, tableView].forEach {
            view.addSubview($0)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
