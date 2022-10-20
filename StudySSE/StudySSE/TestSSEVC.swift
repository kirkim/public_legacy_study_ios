//
//  TestSSEVC.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/18.
//

import UIKit
import IKEventSource
import SnapKit
import RxCocoa
import RxSwift

final class TestSSEVC: UIViewController {
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
  
  private let dataLabel:UILabel = {
    let label = UILabel()
    label.backgroundColor = .blue
    label.font = .systemFont(ofSize: 40)
    
    return label
  }()
  private let nameLabel:UILabel = {
    let label = UILabel()
    label.backgroundColor = .red
    label.font = .systemFont(ofSize: 40)
    
    return label
  }()
  private let idLabel:UILabel = {
    let label = UILabel()
    label.backgroundColor = .brown
    label.font = .systemFont(ofSize: 40)
    
    return label
  }()
  private let connectBtn = UIButton()
  private let disconnectBtn = UIButton()
  private lazy var disposeBag = DisposeBag()
//  private let squareConstraint = NSLayoutConstraint()
  
  lazy var eventSource: EventSource = {
    let serverURL = URL(string: "http://127.0.0.1:8080/sse")!
    let eventSource = EventSource(url: serverURL, headers: ["Authorization": "Bearer basic-auth-token"])
    
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
    
    eventSource.onMessage { [weak self] id, event, data in
      self?.updateLabels(id, event: event, data: data)
    }
    
    eventSource.addEventListener("user-connected") { [weak self] id, event, data in
      self?.updateLabels(id, event: event, data: data)
    }
    
    return eventSource
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    configureLayout()
    configureAttribute()
    setEvent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TestSSEVC {
  
  func updateLabels(_ id: String?, event: String?, data: String?) {
    idLabel.text = id
    nameLabel.text = event
    dataLabel.text = data
  }
  
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//
//    let finalPosition = view.frame.size.width - 50
//
////    squareConstraint.constant = 0
//    view.layoutIfNeeded()
//
//    let animationOptions: UIView.KeyframeAnimationOptions = [
//      UIView.KeyframeAnimationOptions.repeat, UIView.KeyframeAnimationOptions.autoreverse
//    ]
//
//    UIView.animateKeyframes(withDuration: 2,
//                            delay: 0,
//                            options: animationOptions,
//                            animations: { () in
////      self.squareConstraint.constant = finalPosition
//      self.view.layoutIfNeeded()
//    }, completion: nil)
//  }
  
}

extension TestSSEVC {
  
  private func configureAttribute() {
    connectBtn.setTitle("connect", for: .normal)
    disconnectBtn.setTitle("disconnect", for: .normal)
  }
  
  private func configureLayout() {
    view.backgroundColor = .white
    
    view.addSubview(stackView)
    [status, dataLabel, nameLabel, idLabel, connectBtn, disconnectBtn].forEach {
      stackView.addArrangedSubview($0)
    }
    stackView.backgroundColor = .green
    stackView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setEvent() {
    connectBtn.rx.tap
      .bind { [weak self] _ in
        print("connect Clicked!")
        self?.eventSource.connect()
      }
      .disposed(by: disposeBag)
    
    disconnectBtn.rx.tap
      .bind { [weak self] _ in
        print("disconnect Clicked!")
        self?.eventSource.disconnect()
      }
      .disposed(by: disposeBag)
  }
}
