//
//  ViewController.swift
//  Practice_errorHandling
//
//  Created by 김기림 on 2022/08/09.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    enum ButtonType: Int {
        case correctURLButton
        case noURLButton
        case responseErrorButton
        case httttpButton
    }
    
    lazy var button = {(_ title:String, _ type: ButtonType,_ action: Selector) -> UIButton in
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.tag = type.rawValue
        button.titleLabel?.font = .systemFont(ofSize: 30)
        return button
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let correctURLButton = button("correctURL", .correctURLButton, #selector(handleButton))
        let noURLButton = button("noURL", .noURLButton, #selector(handleButton))
        let responseErrorButton = button("maybeResponseError", .responseErrorButton, #selector(handleButton))
        let httttpButton = button("httttp", .httttpButton, #selector(handleButton))
        
        [correctURLButton, noURLButton, httttpButton, responseErrorButton].forEach {
            self.view.addSubview($0)
        }
        correctURLButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-150)
            $0.centerX.equalToSuperview()
        }
        noURLButton.snp.makeConstraints {
            $0.top.equalTo(correctURLButton.snp.bottom).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        responseErrorButton.snp.makeConstraints {
            $0.top.equalTo(noURLButton.snp.bottom).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        httttpButton.snp.makeConstraints {
            $0.top.equalTo(responseErrorButton.snp.bottom).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    @objc private func handleButton(_ sender: UIButton) {
        var url:String {
            switch sender.tag {
            case ButtonType.correctURLButton.rawValue: return "http://localhost:4000/delivery/cache_test/1.jpeg"
            case ButtonType.noURLButton.rawValue: return ""
            case ButtonType.responseErrorButton.rawValue: return "http://localhost:4000/delivery/cache_test/adas"
            case ButtonType.httttpButton.rawValue: return "httttp://localhost:4000/delivery/cache_test/1.jpeg"
            default: return ""
            }
        }
        
        NetworkManager.shared.loadImage(urlString: url) { result in
            switch result {
            case .success(_):
                print("성공")
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

enum CustomError2: Error {
    case appleError
    case orangeError
    var description:String {
        switch self {
        case .appleError:
            return "사과를 주지마세요!"
        case .orangeError:
            return "오렌지를 주지마세요!"
        }
    }
}

extension ViewController {
    
    func giveFruitToFriend() {
        do {
            let answer = try doNotGiveMeAnAppleOrOrange(fruit: "apple")
            print(answer)
        } catch let error {
            guard let error = error as? CustomError2 else {
                print(error)
                return
            }
            print(error.description)
        }
    }
    
    func doNotGiveMeAnAppleOrOrange(fruit: String) throws -> String {
        switch fruit {
        case "apple","사과":
            throw CustomError2.appleError
        case "orange", "귤", "오렌지":
            throw CustomError2.orangeError
        default:
            break
        }
        return "\(fruit)를 줘서 고마워"
    }
    
//    func doNotGiveMeAnAppleOrOrange(fruit: String) -> Bool {
//        switch fruit {
//        case "apple","사과":
//            return false
//        case "orange", "귤", "오렌지":
//            return false
//        default:
//            break
//        }
//        return true
//    }
}
