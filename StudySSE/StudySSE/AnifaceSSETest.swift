//
//  AnifaceSSETest.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/20.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Moya

final class AnifaceSSETest: UIViewController {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let status:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        
        return label
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 40)
        
        return label
    }()
    
    private let connectBtn: UIButton = {
        let button = UIButton()
        button.setTitle("connect", for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        return button
    }()
    
    private let disconnectBtn: UIButton = {
        let button = UIButton()
        button.setTitle("disconnect", for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        return button
    }()
    
    private lazy var disposeBag = DisposeBag()
    private let provider = MoyaProvider<MoyaSSE>(
        session: UrlSessionManager.sharedManager
    )
    
    lazy var eventSource: CustomEventSource = {
//        let serverURL = URL(string: "http://15.164.231.245:8080/progress")!
        let serverURL = URL(string: "http://localhost:8080/sse")!
//        let eventSource = CustomEventSource(url: serverURL, headers: ["Authorization": "Bearer basic-auth-token"])
        let eventSource = CustomEventSource(url: serverURL)
        
        eventSource.onOpen { [weak self] in
            self?.status.backgroundColor = UIColor(red: 166/255, green: 226/255, blue: 46/255, alpha: 1)
            self?.status.text = "CONNECTED"
        }
        
        eventSource.onComplete { [weak self] statusCode, reconnect, error in
            self?.status.backgroundColor = UIColor(red: 249/255, green: 38/255, blue: 114/255, alpha: 1)
            self?.status.text = "DISCONNECTED"
            
            guard reconnect ?? false else { return }
            
            let retryTime = eventSource.retryTime
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(retryTime)) { [weak self] in
                eventSource.connect()
            }
        }
        
        return eventSource
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureLayout()
        setEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnifaceSSETest {
    
    private func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        [status, nameLabel, connectBtn, disconnectBtn, UIView()].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.backgroundColor = .green
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setEvent() {
        connectBtn.rx.tap
            .bind { [weak self] _ in
                print("connect SSE Clicked!")
                self?.eventSource.connect()
//                self?.postRequest()
            }
            .disposed(by: disposeBag)
        
        disconnectBtn.rx.tap
            .bind { [weak self] _ in
                print("disconnect Clicked!")
                self?.eventSource.disconnect()
            }
            .disposed(by: disposeBag)
    }
    
    private func postRequest() {
        
        guard let image = UIImage(named: "suhyun")?.rotateImage(),
              let targetImageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        self.provider.request(.model1(targetImageData: targetImageData, imageID: "sample"), completion: { result in
            switch result {
            case .success(let response):
              print(response)
              if (200..<300).contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder()
                  .decode(ImageData.self, from: response.data) else {
                  
                  return print("디코딩에러")
                }
                  print(decodedData)
              } else {
                
                print("얼굴 못찾음")
              }
            case .failure(let error):
              print(error)
            }
        })
    }
}
