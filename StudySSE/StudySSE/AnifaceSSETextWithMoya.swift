//
//  AnifaceSSETextWithMoya.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Moya

final class AnifaceSSETestWithMoya: UIViewController {
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

  private let connectBtn = UIButton()
  private let disconnectBtn = UIButton()
  private lazy var disposeBag = DisposeBag()

    let provider = MoyaProvider<MoyaSSE>(
        session: .default
    )
    

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

extension AnifaceSSETestWithMoya {
  
  func updateLabels(_ id: String?, event: String?, data: String?) {
      nameLabel.text = (id ?? "") + (event ?? "") + (data ?? "")
  }
}

extension AnifaceSSETestWithMoya {
  
  private func configureAttribute() {
    connectBtn.setTitle("connect", for: .normal)
    disconnectBtn.setTitle("disconnect", for: .normal)
  }
  
  private func configureLayout() {
    view.backgroundColor = .white
    
    view.addSubview(stackView)
    [status, nameLabel, connectBtn, disconnectBtn].forEach {
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
//        self?.eventSource.connect()
         
      }
      .disposed(by: disposeBag)
    
    disconnectBtn.rx.tap
      .bind { [weak self] _ in
        print("disconnect Clicked!")

      }
      .disposed(by: disposeBag)
  }
}
