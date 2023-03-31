//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/27.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    weak var locationDelegate: LocationDelegate?
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    func changeGeocoder(location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemark, error in
            
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let firstLocation = placemark?.last else { return }
            completion(firstLocation)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationDelegate?.didUpdateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
            print("asdf")
            manager.requestLocation()
            // 여기서 viewcontroller에다가 delegate를 준 다음, 이 신호를 받은 viewcontroller는 weatherController의 함수 실행
        case .denied, .restricted:
            print("ggod")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
}
