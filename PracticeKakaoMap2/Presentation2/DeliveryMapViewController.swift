//
//  DeliveryMapViewController.swift
//  PracticeKakaoMap2
//
//  Created by 김기림 on 2022/06/12.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit
import SystemConfiguration

class DeliveryMapViewController: UIViewController {
    private let disposeBage = DisposeBag()
    
    private let locationManager = CLLocationManager()
//    private let mapView = MTMapView()
    private let mapView = UIView()
    private let addressView = UIView()
    private let submitButton = UIView()
    
    private let containerStackView = UIStackView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
//        mapView.delegate = self
        locationManager.delegate = self
        
        attribute()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func attribute() {
        title = "지도에서 위치 확인"
        view.backgroundColor = .white
        //temp
        mapView.backgroundColor = .red
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        
        addressView.backgroundColor = .yellow
        
        submitButton.backgroundColor = .brown
    }
    
    private func layout() {
        [UIView(), addressView, submitButton, UIView()].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [mapView, containerStackView].forEach {
            view.addSubview($0)
        }
        
        addressView.snp.makeConstraints {
            $0.height.equalTo(60)
        }

        submitButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        containerStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
        
        mapView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(containerStackView.snp.top)
        }
    }
}

//MARK: - MTMapViewDelegate
extension DeliveryMapViewController: MTMapViewDelegate {
    
}

//MARK: - CLLocationManagerDelegate
extension DeliveryMapViewController: CLLocationManagerDelegate {
    
}
