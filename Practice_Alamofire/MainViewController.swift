//
//  MainViewController.swift
//  Practice_Alamofire
//
//  Created by 김기림 on 2022/08/12.
//

import UIKit

class MainViewController: UIViewController {
    private let networkManager = URLSessionManager.shared
    
    lazy var button:UIButton = {
        let btn = UIButton()
        btn.setTitle(" 네트워크요청 ", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleButton() {
        networkManager.getStoreDetail(storeCode: 1) { result in
            switch result {
            case let .success(data):
                print(data)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setting() {
        view.backgroundColor = .green
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension MainViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("a")
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        <#code#>
    }
}
