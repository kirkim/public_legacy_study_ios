//
//  AddressPageViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/13.
//

import UIKit
import SnapKit

class AddressPageViewController: UIViewController {
    private let containerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let searchView = UIView()
    private let openMapView = UIView()
    
    private let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        view.backgroundColor = .systemGray
        
        titleLabel.text = "주소 설정"
        titleLabel.font = .systemFont(ofSize: 22, weight: .medium)
        titleLabel.textAlignment = .center
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
        containerStackView.backgroundColor = .white
        
        // temp
        titleLabel.backgroundColor = .green
        searchView.backgroundColor = .blue
        openMapView.backgroundColor = .orange
        tableView.backgroundColor = .brown
    }
    
    private func layout() {
        [titleLabel, searchView, openMapView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        searchView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        openMapView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        [containerStackView, tableView].forEach {
            view.addSubview($0)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
