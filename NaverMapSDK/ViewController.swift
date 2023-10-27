//
//  ViewController.swift
//  NaverMapSDK
//
//  Created by 황재영 on 10/27/23.
//

import UIKit
import NMapsMap
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    let mapView = NMFMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()


        naverMap()

    }

    func naverMap() {
        var coord = NMGLatLng(lat: 37.5670135, lng: 126.9783740)

        self.mapView.frame = self.view.frame
        self.mapView.mapType = .terrain // .hybrid, .navi, .satelite, .basic, .none 지도 표현 속성
        mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true) // 건물 레이어 그룹 활성화
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: false) // 대중교통 레이어 그룹 비활성화

        mapView.isIndoorMapEnabled = true // 실내지도 활성화 -> basic과 terrain 타입만 지원
        mapView.isNightModeEnabled = true // 야간모드(다크모드) 활성화 -> navi 타입만 지원
        mapView.lightness = 0.3 // 지도 밝기 조절, 기본값 0, -1~1, 1에 가까울수록 밝아짐

        NSLog("위도: %f, 경도: %f", coord.lat ,coord.lng) // 위경도 로그 표시

        self.view.addSubview(mapView)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            //location5
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
                self.locationManager.startUpdatingLocation() // 중요!
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
            case .denied:
                print("GPS 권한 요청 거부됨")
            default:
                print("GPS: Default")
            }
        }


}

