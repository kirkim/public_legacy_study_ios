//
//  ViewController.swift
//  Practice_kakaoLogin
//
//  Created by 김기림 on 2022/08/06.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {

    var subscriptions = Set<AnyCancellable>()
    
    lazy var kakaoLoginStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 여부 라벨"
        label.backgroundColor = .gray
        return label
    }()
    
//    lazy var kakaoLoginButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("카카오 로그인", for: .normal)
//        btn.configuration = .filled()
//        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    lazy var kakaoLogoutButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("카카오 로그아웃", for: .normal)
//        btn.configuration = .filled()
//        btn.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    lazy var kakaoButton = { (_ title: String, _ action: Selector) -> UIButton in
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.configuration = .filled()
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    lazy var stackView: UIStackView = {
       let stack = UIStackView()
        stack.spacing = 20
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var kakaoAuthViewModel: KakaoAuthViewModel = { KakaoAuthViewModel() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        kakaoLoginStatusLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(70)
        }
        
        let kakaoLoginButton = kakaoButton("카카오 로그인", #selector(loginBtnClicked))
        let kakaoLogoutButton = kakaoButton("카카오 로그아웃", #selector(logoutBtnClicked))
        
        [kakaoLoginStatusLabel, kakaoLoginButton, kakaoLogoutButton].forEach {
            stackView.addArrangedSubview($0)
        }
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        setBindings()
        
    } // viewDidLoad
    
    //MARK: - 버튼액션
    @objc func loginBtnClicked() {
        print("LoginBtnClicked() called")
        kakaoAuthViewModel.kakaoLogin()
    }
    
    @objc func logoutBtnClicked() {
        print("LogoutBtnClicked() called")
        kakaoAuthViewModel.kakaoLogout()
    }

} // ViewController

//MARK: - 뷰모델 바인딩
extension ViewController {
    fileprivate func setBindings() {
//        self.kakaoAuthViewModel.$isLoggedIn.sink { [weak self] isLoggedIn in
//            self?.kakaoLoginStatusLabel.text = isLoggedIn ? "로그인 상태" : "로그아웃 상태"
//        }
//        .store(in: &subscriptions)
        
        self.kakaoAuthViewModel.loginStatusInfo
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: kakaoLoginStatusLabel)
            .store(in: &subscriptions)
    }
}

#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
}

struct ViewControllerPrepresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}

#endif
