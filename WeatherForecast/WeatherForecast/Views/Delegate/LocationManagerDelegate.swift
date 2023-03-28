//
//  ViewControllerDelegate.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/22.
//

import UIKit
import CoreLocation

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let recentLocation = manager.location else {
            return
        }
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(recentLocation, preferredLocale: locale) { placemark, error in
            guard error == nil else {
                return
            }
            
            guard let firstLocation = placemark?.last else { return }
            print("나는 locationManager: \(firstLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("ggod")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
}
