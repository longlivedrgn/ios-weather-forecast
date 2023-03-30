//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/27.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager {
    
    weak var locationDelegate: LocationDelegate?
    
    override init() {
        super.init()
        desiredAccuracy = kCLLocationAccuracyKilometer
        requestWhenInUseAuthorization()
        delegate = self
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
        
        if locations.last != manager.location {
            guard let recentLocation = locations.last else {
                print("LocationManager: recentLocation에 들어온 주소 없음.")
                return
            }
            locationDelegate?.send(location: recentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
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
