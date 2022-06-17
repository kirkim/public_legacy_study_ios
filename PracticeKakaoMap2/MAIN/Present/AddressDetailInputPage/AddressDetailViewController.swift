//
//  AddressDetailViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/15.
//

import UIKit
import RxCocoa
import RxSwift

class AddressDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let containerStackView = UIStackView()
    private let topPaddingView = UIView()
    private let customNavigationBar = AddressNavigationBar(title: "상세 정보 입력")
    private let addressLabel: DetailAddressLabelView
    private let customTextField = DetailAddressTextField()
    private let selectView = SelectAddressTypeStackView()
    private let presentMapView = PresentMapView(.targetPoint)
    private let submitButton = UILabel()
    
    private let viewModel = AddressDetailViewModel()
    private let data: SubAddressByTextData
    
    init(data: SubAddressByTextData) {
        self.data = data
        self.addressLabel = DetailAddressLabelView(data)
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
        self.navigationController?.navigationBar.isHidden = true
        customTextField.becomeFirstResponder()
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(_ viewModel: AddressDetailViewModel) {
        self.selectView.bind(viewModel.selectAddressTypeViewmodel)
        self.customNavigationBar.bind(viewModel.navigationBarViewModel)
        
        viewModel.popVC
            .emit(to: self.rx.popVC)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = .systemGray5
        
        topPaddingView.backgroundColor = .white
        customNavigationBar.backgroundColor = .white
        submitButton.text = "완료"
        submitButton.backgroundColor = .systemBrown
        submitButton.textColor = .white
        submitButton.textAlignment = .center
        
        containerStackView.backgroundColor = .white
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
    }
    
    private func layout() {
        [topPaddingView, customNavigationBar, containerStackView, submitButton].forEach {
            view.addSubview($0)
        }
        
        let topPadding = 25
        let navigationHeight = 40
        let addressLabelHeight = 70
        let searchBarHeight = 50
        let selectViewHeight = 70
        let presentMapHeight = 50
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
        
        let windowHeight = self.view.frame.height
        let windowWidth = self.view.frame.width
        let submitButtonHeight = 50.0
        let y = windowHeight - submitButtonHeight - 100.0
        submitButton.frame = CGRect(x: 0.0, y: y, width: windowWidth, height: submitButtonHeight)
        
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

extension AddressDetailViewController {
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - 50
            
            
            self.submitButton.frame.origin.y -= keyboardHeight
        }
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - 50
            print(keyboardHeight)
            self.submitButton.frame.origin.y += keyboardHeight
        }
    }
 
}

extension Reactive where Base: AddressDetailViewController {
    var popVC: Binder<Void> {
        return Binder(base) { base, data in
            base.navigationController?.popViewController(animated: true)
        }
    }
}
