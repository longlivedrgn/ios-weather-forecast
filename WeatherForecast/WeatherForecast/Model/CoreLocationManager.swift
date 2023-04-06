//
//  CoreLocationManager.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CoreLocationManager: NSObject {
    
    weak var delegate: CoreLocationManagerDelegate?
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func changeGeocoder(location: CLLocation) async throws -> CLPlacemark? {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        let placemark = try await geocoder.reverseGeocodeLocation(location)
        let firstLocation = placemark.last
        return firstLocation
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        delegate?.coreLocationManager(self, didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
}
