//
//  ViewControllerDelegate.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/22.
//

import UIKit
import CoreLocation

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    var address = ""
    var coordinate = CLLocation()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let recentLocation = manager.location else {
            print("?")
            return
        }
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(recentLocation, preferredLocale: locale) { placemark, error in
            guard error == nil else {
                return
            }
            
            guard let firstLocation = placemark?.last else { return }
            guard let name = firstLocation.name else { return }
            guard let location = firstLocation.location else { return }
            self.address = name
            self.coordinate = location
            return
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
