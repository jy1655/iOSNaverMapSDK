//
//  ViewController.swift
//  NaverMapSDK
//  OS version require 17.0
//  Created by 황재영 on 10/27/23.
//

import UIKit
import NMapsMap
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewTouchDelegate {

    var locationManager: CLLocationManager!
    let naverMapView = NMFNaverMapView()
    let marker = NMFMarker()

    var userLocation: CLLocation?
    var tappedLocation: NMGLatLng?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치정보 권한 요구

        naverMapView.mapView.touchDelegate = self // Touch 델리게이트 설정

        naverMapUI()
        button()


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let mapViewHeight = self.view.bounds.height / 2
//        let mapViewWidth = self.view.bounds.width / 2

        naverMapView.mapView.frame = self.view.bounds // 지도 크기 설정(화면전체)
        naverMapView.frame = self.view.bounds // naverMapView와 관련된UI 추가(화면 전체 기준)
//            naverMapView.mapView.frame = CGRect(x: mapViewWidth/2, y: mapViewHeight/2, width: mapViewWidth, height: mapViewHeight) // 지도가 표시되는 범위와 크기 설정, 지도 자체가 짤려서 UI도 짤리는듯?
        print("지도 로딩")
        naverMapView.mapView.positionMode = .normal // 지도 위치를 GPS위치로 설정
        print("position mode:\(naverMapView.mapView.positionMode)")
    }


    @objc func findWay() {
        guard let userLocation = userLocation, let tappedLocation = tappedLocation else {
            print("위치 정보가 없습니다.")
            return
        }

        let start = "\(userLocation.coordinate.longitude),\(userLocation.coordinate.latitude)"
        let goal = "\(tappedLocation.lng),\(tappedLocation.lat)"
        let option = "trafast" // 경로 옵션, 필요한 옵션에 따라 변경 가능

        let drivingAPI = DrivingAPI.shared
        drivingAPI.driveRoute(start: start, goal: goal, option: option) { (result, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            // 결과 처리
            if let result = result {
                print(result)
                // 결과에 따라 경로를 지도에 표시하는 로직 구현
                // ...
            }
        }
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { // 앱이 실행될 때 Gps실행,접근 가능 여부 콜백
            //location5
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
                self.locationManager.startUpdatingLocation() // 중요! 권한 사용
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
            case .denied:
                print("GPS 권한 요청 거부됨")
            default:
                print("GPS: Default")
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                userLocation = location // 사용자 위치 저장
                let latLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
                print("위도: \(latLng.lat), 경도: \(latLng.lng)")
                // 필요한 경우 지도의 중심을 사용자의 현재 위치로 설정
                 let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
                naverMapView.mapView.moveCamera(cameraUpdate)
            }
        }

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) { // 지도를 탭 했을때 좌표 파라미터 콜백
        print("\(latlng.lat), \(latlng.lng)")

        tappedLocation = latlng // 탭한 위치 저장

        // 마커 생성 및 설정
        marker.position = latlng
        marker.mapView = mapView
    }

    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        if symbol.caption == "서울특별시청" {
            print("서울시청 탭")
            return true // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음

        } else {
            print("symbol 탭")
            return false
        }
    }


    func naverMapUI() {
        naverMapView.mapView.mapType = .basic // .hybrid, .navi, .satelite, .basic, .none, .terrain 지도 표현 속성

        naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true) // 건물 레이어 그룹 활성화
        naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: false) // 대중교통 레이어 그룹 비활성화

        naverMapView.mapView.isIndoorMapEnabled = true // 실내지도 활성화 -> basic과 terrain 타입만 지원
        naverMapView.mapView.isNightModeEnabled = true // 야간모드(다크모드) 활성화 -> navi 타입만 지원
        naverMapView.mapView.lightness = 0.3 // 지도 밝기 조절, 기본값 0, -1 ~ 1, 1에 가까울수록 밝아짐

        naverMapView.mapView.isScrollGestureEnabled = true // 제스쳐 활성화
        print("제스쳐 활성화: \(naverMapView.mapView.isScrollGestureEnabled)")
        naverMapView.mapView.isTiltGestureEnabled = false // 기울이기 제스쳐 비활성화

        naverMapView.showCompass = false // 나침반 비활성화
        naverMapView.showLocationButton = true // 현위치 버튼 활성화
        naverMapView.showScaleBar = true // 지도의 축척 표현
        naverMapView.showZoomControls = true // 줌버튼 활성화
        naverMapView.showIndoorLevelPicker = true // 실내지도의 층 정보 표시



        self.view.addSubview(naverMapView) // naverMapView와 관련된UI 추가
    }


    func button() {
        let button = UIButton(type: .system) // .system = 기본적인 버튼 스타일

        button.setTitle("경로탐색", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 100, y: 300, width: 50, height: 50) // 버튼 속성

        button.addTarget(self, action: #selector (findWay), for: .touchUpInside) // 버튼에 연결될 기능

        view.addSubview(button)
    }

//    func cameraMove() {
//        var cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 377.5666102, lng: 126.9783881)) // 카메라 위치 설정
//        cameraUpdate.animation = .easeIn // 카메라가 부드럽게 가속하면서 이동함. 가까운거리에 적합
//
//        cameraUpdate.animationDuration = 2
//        mapView.moveCamera(cameraUpdate) { (isCancelled) in // -moveCamera:대신 -moveCamera:completion:의 completion block을 사용하여 카메라 이동에 대한 결과 콜백
//            if isCancelled {
//                print("카메라 이동 취소")
//            } else {
//                print("카메라 이동 완료")
//            }
//        }

//        mapView.moveCamera(cameraUpdate)

//    }


}

