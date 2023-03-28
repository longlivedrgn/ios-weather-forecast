//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/24.
//

import UIKit
import CoreLocation

final class WeatherController {
    
    init() {
        locationManager.locationDelegate = self
    }
    
    struct CurrentWeather {
        let image: UIImage
        let address: String?
        let temperatures: Temperature
    }
    
    struct FiveDaysForecast {
        let image: UIImage
        let date: String
        let temperature: Double
    }
    
    private let networkModel = NetworkModel()
    private let weatherAPIManager = WeatherAPIManager(networkModel: NetworkModel(session: URLSession.shared))
    private let locationManager = LocationManager()
    
    func makeCoordinate(from location: CLLocation) -> Coordinate {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
    func makeCurrentWeather(location: CLLocation) {
        
        // locationManager: coordinate -> address
        let group = DispatchGroup()
        var data: CurrentWeather?
        
        locationManager.changeGeocoder(location: location) { place in

            print(place?.locality)
            print(place?.subLocality)
            let address = "\(place?.locality) \(place?.subLocality)"
            
            // 1. coordinate 주소 가져오기
            let coordinate = self.makeCoordinate(from: location)
            // 2. currentWeather 가져오기
            guard let weatherData = self.weatherAPIManager.fetchWeatherInformation(of: .currentWeather, in: coordinate) as? CurrentWeatherDTO else { return }
            
            guard let imageIcon = weatherData.weather.first?.icon else { return }
            guard let weatherImage = self.weatherAPIManager.fetchWeatherImage(icon: imageIcon) else { return }
            
            let currentWeather = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
            data = currentWeather
            print("여긴 안: \(data)")

        }
        
        print("여긴 밖: \(data)")
    }
}


extension WeatherController: locationDelegate {
    func send(location: CLLocation) {
        makeCurrentWeather(location: location)
    }
    
}
