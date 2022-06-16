//
//  AddressDetailViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/15.
//

import UIKit

class AddressDetailViewController: UIViewController {
    private let containerStackView = UIStackView()
    
    private let topPaddingView = UIView()
    private let customNavigationBar = AddressNavigationBar(title: "상세 정보 입력")
    private let addressLabel = UILabel()
    private let customTextField = DetailAddressTextField()
    private let selectView = SelectAddressTypeStackView()
    private let presentMapView = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        customTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func attribute() {
        view.backgroundColor = .systemGray5
        
        topPaddingView.backgroundColor = .white
        customNavigationBar.backgroundColor = .white
        
        containerStackView.backgroundColor = .white
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
        
        //MARK: TEMPORARY
        addressLabel.backgroundColor = .red
        selectView.backgroundColor = .green
        presentMapView.backgroundColor = .brown
    }
    
    private func layout() {
        [topPaddingView, customNavigationBar, containerStackView].forEach {
            view.addSubview($0)
        }
        
        let topPadding = 30
        let navigationHeight = 40
        let addressLabelHeight = 60
        let searchBarHeight = 50
        let selectViewHeight = 70
        let presentMapHeight = 40
        let containerHeight = addressLabelHeight + searchBarHeight + selectViewHeight + presentMapHeight + 30
        
        topPaddingView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(topPadding)
        }
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(topPaddingView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }
        
        [addressLabel, customTextField, selectView, presentMapView].forEach {
            self.containerStackView.addArrangedSubview($0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(addressLabelHeight)
        }
        
        customTextField.snp.makeConstraints {
            $0.height.equalTo(searchBarHeight)
        }
        
        selectView.snp.makeConstraints {
            $0.height.equalTo(selectViewHeight)
        }
        
        presentMapView.snp.makeConstraints {
            $0.height.equalTo(presentMapHeight)
        }
        
        
        
    }
}
