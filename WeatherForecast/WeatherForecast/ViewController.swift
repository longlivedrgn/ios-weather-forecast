//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setLocationManager()
        let network = WeatherAPIManager()
        let coordinate = Coordinate(longitude: 126, latitude: 37)
        network.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate)
    }
    
    fileprivate func setLocationManager() {
        // 델리게이트를 설정하고,
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        DispatchQueue.global().async {
            // 필수적이지는 않지만, 서비스가 가능한 지 아닌 지 확인할 용도로 사용한다. -> 만약 false인데 location을 가져오려고하면 didFailWithError 호출!
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
            else {
                print("위치 서비스 허용 off")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude else { return }
        guard let longitude = locations.last?.coordinate.longitude else { return }
        print(latitude)
        print(longitude)
        guard let location = locations.last else { return }
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: {(placemarks, error) in
            guard let address = placemarks else { return }
            print(address.last?.name ?? "띠용")
        })
    }
    
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}
