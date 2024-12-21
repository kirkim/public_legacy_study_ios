//
//  AddressSearchViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

class AddressSearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = AddressSearchViewModel()
    
    private let containerStackView = UIStackView()
    
    private let customNavigationBar = AddressNavigationBar(title: "주소 검색")
    private let customSearchBar = AddressSearchBar()
    private let presentMapButtonView = PresentMapButtonView(.currentPoint)
    private let tableView = UITableView()
    private let backgroundView = AddressBackgroundView()
    private let addressNoDataView = AddressNoDataView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
        bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.isHidden = true
        self.addressNoDataView.isHidden = true
        customSearchBar.becomeFirstResponder()
    }
    
    private func bind(_ viewModel: AddressSearchViewModel) {
        customSearchBar.bind(viewModel.searchBarViewModel)
        
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "AddressSearchCell", for: IndexPath(row: row, section: 0)) as! AddressSearchCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as! AddressSearchCell
                guard let data = cell.data else { return }
                let vc = AddressDetailViewController(data: data)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.tableViewState
            .emit(onNext: { state in
                switch state {
                case .find:
                    self.addressNoDataView.isHidden = true
                    self.tableView.isHidden = false
                    self.backgroundView.isHidden = true
                case .noData:
                    self.addressNoDataView.isHidden = false
                    self.backgroundView.isHidden = true
                    self.tableView.isHidden = true
                case .nothing:
                    self.addressNoDataView.isHidden = true
                    self.tableView.isHidden = true
                    self.backgroundView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        presentMapButtonView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let vc = DeliveryMapViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .systemGray6
        
        customNavigationBar.rootViewController = self
        
        containerStackView.backgroundColor = .white
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
        
        tableView.register(AddressSearchCell.self, forCellReuseIdentifier: "AddressSearchCell")
    }
    
    private func layout() {
        [customSearchBar, presentMapButtonView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        let searchBarHeight = 40
        let presentMapViewButtonHeight = 50
//        let containerHeight = navigationBarHeight + searchBarHeight + presentMapViewButtonHeight
        
        customSearchBar.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
        }
        
        presentMapButtonView.snp.makeConstraints {
            $0.height.equalTo(presentMapViewButtonHeight)
        }
        
        [customNavigationBar, containerStackView, addressNoDataView, backgroundView, tableView].forEach {
            self.view.addSubview($0)
        }
        
        customNavigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(containerHeight)
        }
        
        addressNoDataView.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
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
