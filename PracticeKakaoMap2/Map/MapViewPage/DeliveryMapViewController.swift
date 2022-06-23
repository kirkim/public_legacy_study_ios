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
    
    
    // 커스텀마커
    private let customMarker = UIImageView(image: UIImage(named: "mapPoint"))
    private let centerPointView = UIView()
    private var customMarkerY: Double?
    
    private let viewModel = DeliveryMapViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)

        attribute()
        layout()
        bind()
        temp()
    }
    
    func temp() {
        mapView.delegate = self
        mapView.setZoomLevel(.zero, animated: true)
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
//        mapView.currentLocationTrackingMode = .off
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.59673141607238, longitude: 127.01187180606017)), animated: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.mapInfoView.bind(viewModel.mapInfoViewModel)
    }
    
    private func attribute() {
        locationManager.delegate = self
        
        title = "지도에서 위치 확인"
        view.backgroundColor = .white
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        
        submitButton.backgroundColor = .brown
        submitButton.text = "이 위치로 주소 설정"
        submitButton.textAlignment = .center
        submitButton.textColor = .white
        submitButton.font = .systemFont(ofSize: 20, weight: .bold)
        
        centerPointView.backgroundColor = .black
        centerPointView.layer.cornerRadius = 5
    }
    
    private func layout() {
        [UIView(), mapInfoView, submitButton, UIView()].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [mapView, containerStackView, centerPointView,customMarker].forEach {
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
        
        centerPointView.snp.makeConstraints {
            $0.width.height.equalTo(10)
            $0.centerX.equalTo(mapView.snp.centerX)
            $0.centerY.equalTo(mapView.snp.centerY)
        }
        
        customMarker.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerX.equalTo(mapView.snp.centerX)
            $0.centerY.equalTo(mapView.snp.centerY).offset(-20)
        }
    }
}

//MARK: - MTMapViewDelegate
extension DeliveryMapViewController: MTMapViewDelegate {
//    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
//
//    }
       
    func mapView(_ mapView: MTMapView!, dragStartedOn mapPoint: MTMapPoint!) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            self?.customMarker.frame.origin.y = (self?.customMarkerY)! - 20
        }
    }
    
    func mapView(_ mapView: MTMapView!, dragEndedOn mapPoint: MTMapPoint!) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            self?.customMarker.frame.origin.y = (self?.customMarkerY)!
        }
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
        if (customMarkerY == nil) {
            customMarkerY = customMarker.frame.origin.y
        }
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
        case .authorizedAlways:
            print("GPS 권한 항상 허락 설정됨")
        case .authorizedWhenInUse:
            print("GPS 권한 앱사용중에만 허락 설정됨")
        case .notDetermined:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS default")
        }
        return
    }
}
