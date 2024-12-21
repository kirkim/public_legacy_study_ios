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
    private var viewModel: DeliveryMapViewModel?
    
    private let locationManager = CLLocationManager()
    
    private let customNavigationBar = AddressNavigationBar(title: "지도에서 위치 확인")
    private let mapView = MTMapView()
    private let mapInfoView = MapInfoView()
    private let submitButton = UILabel()
    private let containerStackView = UIStackView()
    private let currentLocationButton = UIButton()
    
    // 커스텀마커
    private let customMarker = UIImageView(image: UIImage(named: "mapPoint"))
    private let centerPointView = UIView()
    private var customMarkerY: Double?
    //
    private var isInitMapPoint: Bool = false
    private var mapPoint: MTMapPoint?
        
    init(mapPoint: MTMapPoint? = nil) {
        super.init(nibName: nil, bundle: nil)

        attribute()
        layout()
        bind()
        initMapView(mapPoint)
    }
    
    private func initMapView(_ mapPoint: MTMapPoint?) {
        mapView.delegate = self
        mapView.setZoomLevel(.zero, animated: true)
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        self.mapPoint = mapPoint
        // 초기화시 지정위치가 있으면 지정위치로 이동
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func bind(_ viewModel:DeliveryMapViewModel = DeliveryMapViewModel()) {
        self.viewModel = viewModel
        mapInfoView.bind(viewModel.mapInfoViewModel)
        
        viewModel.setMapCenter.emit(to: mapView.rx.setMapCenterPoint).disposed(by: disposeBage)

        currentLocationButton.rx.tap.bind(to: viewModel.currentLocationButtonTapped).disposed(by: disposeBage)
    }
    
    private func attribute() {
        locationManager.delegate = self
        
        view.backgroundColor = .white
        
        customNavigationBar.rootViewController = self
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        
        submitButton.backgroundColor = .brown
        submitButton.text = "이 위치로 주소 설정"
        submitButton.textAlignment = .center
        submitButton.textColor = .white
        submitButton.font = .systemFont(ofSize: 20, weight: .bold)
        
        centerPointView.backgroundColor = .black
        centerPointView.layer.cornerRadius = 5
        
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
    }
    
    private func layout() {
        [UIView(), mapInfoView, submitButton, UIView()].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        mapInfoView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        [customNavigationBar, mapView, containerStackView, currentLocationButton, centerPointView, customMarker].forEach {
            view.addSubview($0)
        }
        
        customNavigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(containerStackView.snp.top)
        }
        
        containerStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalTo(mapView).offset(16)
            $0.bottom.equalTo(mapView).offset(-16)
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
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        viewModel!.currentLocation.accept(location)
#if DEBUG
        viewModel!.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.118341)))
#else
        viewModel!.currentLocation.accept(location)
#endif
        
        if (isInitMapPoint == false) {
            isInitMapPoint = true
            if (mapPoint != nil) {
                mapView.setMapCenter(mapPoint, animated: true)
                print("넘겼음\(mapPoint!)")
                viewModel!.mapCenterPoint.accept(mapPoint!)
            } else {
                viewModel!.initSetMapCenter.accept(Void())
                viewModel!.mapCenterPoint.accept(location)
            }
        }
    }
    
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
        viewModel!.mapCenterPoint.accept(mapCenterPoint)
        if (customMarkerY == nil) {
            customMarkerY = customMarker.frame.origin.y
        }
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
