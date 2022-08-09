//
//  ViewController2.swift
//  Practice_errorHandling
//
//  Created by 김기림 on 2022/08/09.
//

import UIKit

enum CustomError2: Error {
    case appleError
    case orangeError
    var description:String {
        switch self {
        case .appleError:
            return "error: 사과를 주지마세요!"
        case .orangeError:
            return "error: 오렌지를 주지마세요!"
        }
    }
}

final class ViewController2: UIViewController {
    enum ButtonType: Int {
        case correctURLButton
        case noURLButton
        case responseErrorButton
        case httttpButton
    }
    
    lazy var button = {(_ title:String, _ tag: Int,_ action: Selector) -> UIButton in
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.tag = tag
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
        let appleButton = button(" 사과주기 ", 0, #selector(handleButton))
        let orangeButton = button(" 오렌지주기 ", 1, #selector(handleButton))
        let grapeButton = button(" 포도주기 ", 2, #selector(handleButton))
        
        [appleButton, orangeButton, grapeButton].forEach {
            view.addSubview($0)
        }
        
        appleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-150)
        }
        
        orangeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(appleButton.snp.bottom).offset(30)
        }
        
        grapeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(orangeButton.snp.bottom).offset(30)
        }
    }
    
    @objc func handleButton(_ sender: UIButton) {
        var fruit:String {
            switch sender.tag {
            case 0: return "사과"
            case 1: return "오렌지"
            case 2: return "포도"
            default: return ""
            }
        }
        
        do {
            let answer = try doNotGiveMeAnAppleOrOrange(fruit: fruit)
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
}
