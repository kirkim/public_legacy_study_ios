//
//  AddressSearchViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import RxSwift

class AddressSearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = AddressSearchViewModel()
    
    private let containerStackView = UIStackView()
    
    private let customNavigationBar = AddressSearchNavigationBarView()
    private let customSearchBar = AddressSearchBar()
    private let presentMapViewButton = PresentMapView()
    private let tableView = UITableView()
    private let backgroundView = AddressBackgroundView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
        bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.isHidden = true
        customSearchBar.becomeFirstResponder()
    }
    
    private func bind(_ viewModel: AddressSearchViewModel) {
        customNavigationBar.bind(viewModel.navigationBarViewModel)
        
        viewModel.popView
            .emit(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.view.backgroundColor = .systemGray6
        
        containerStackView.backgroundColor = .white
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
        
    }
    
    private func layout() {
        [customNavigationBar, customSearchBar, presentMapViewButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        let navigationBarHeight = 40
        let searchBarHeight = 40
        let presentMapViewButtonHeight = 40
        let containerHeight = navigationBarHeight + searchBarHeight + presentMapViewButtonHeight
        
        customNavigationBar.snp.makeConstraints {
            $0.height.equalTo(navigationBarHeight)
        }
        
        customSearchBar.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
        }
        
        presentMapViewButton.snp.makeConstraints {
            $0.height.equalTo(presentMapViewButtonHeight)
        }
        
        [containerStackView, backgroundView, tableView].forEach {
            self.view.addSubview($0)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }
        
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(containerStackView.snp.bottom)
        }
    }
}
