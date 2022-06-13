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
import RxGesture

class DeliveryMapViewController: UIViewController {
    private let disposeBage = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private let mapView = MTMapView()
    private let mapInfoView = MapInfoView()
    private let submitButton = UILabel()
    
    private let containerStackView = UIStackView()
    
    private let viewModel = DeliveryMapViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        mapView.delegate = self
        locationManager.delegate = self
        
        attribute()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.mapInfoView.bind(viewModel.mapInfoViewModel)
    }
    
    private func attribute() {
        title = "지도에서 위치 확인"
        view.backgroundColor = .white
        mapView.showCurrentLocationMarker = true
        mapView.setZoomLevel(.zero, animated: true)
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        
        submitButton.backgroundColor = .brown
        submitButton.text = "이 위치로 주소 설정"
        submitButton.textAlignment = .center
        submitButton.textColor = .white
        submitButton.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private func layout() {
        [UIView(), mapInfoView, submitButton, UIView()].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [mapView, containerStackView].forEach {
            view.addSubview($0)
        }
        
        mapInfoView.snp.makeConstraints {
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
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
        let poitem = MTMapPOIItem()
        poitem.mapPoint = mapCenterPoint
        poitem.markerType = .redPin
        
        mapView.removeAllPOIItems()
        mapView.add(poitem)
    }
}

//MARK: - CLLocationManagerDelegate
extension DeliveryMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways,
                .authorizedWhenInUse,
                .notDetermined:
            return
        default:
            return
        }
    }
}
