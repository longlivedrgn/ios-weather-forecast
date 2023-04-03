//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
    
    struct CurrentWeather: Identifiable {
        let id = UUID()
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    func makeCurrentAddress(locationManager: CoreLocationManager,
                            location: CLLocation,
                            completion: @escaping (String) -> Void
    ) {
        locationManager.changeGeocoder(location: location) { place in
            
            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }
            let address = "\(locality) \(subLocality)"
            completion(address)
        }
    }
    
    func makeCurrentInformation(weatherAPIManager: WeatherAPIManager?,
                                coordinate: Coordinate,
                                location: CLLocation,
                                address: String,
                                completion: @escaping (String, CurrentWeatherDTO) -> Void
    ) {
        weatherAPIManager?.fetchWeatherInformation(of: .currentWeather, in: coordinate) { data in
            
            guard let weatherData = data as? CurrentWeatherDTO else { return }
            guard let icon = weatherData.weather.first?.icon else { return }
            
            completion(icon, weatherData)
        }
    }
    
    func makeCurrentImage(weatherAPIManager: WeatherAPIManager?,
                          iconString: String,
                          address: String,
                          weatherData: CurrentWeatherDTO,
                          completion: @escaping (CurrentWeather) -> Void
    ) {
        weatherAPIManager?.fetchWeatherImage(icon: iconString) { weatherImage in
            
            let currentWeatherData = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
            completion(currentWeatherData)
        }
    }
}

