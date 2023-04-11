//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
        
    struct CurrentWeather {
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    func fetchCurrentAddress(locationManager: CoreLocationManager,
                             location: CLLocation) async throws -> String {
        
        let location = try await locationManager.changeGeocoder(location: location)
        
        guard let locality = location?.locality, let subLocality = location?.subLocality else {
            throw NetworkError.failedTypeCasting
        }
        
        let address = "\(locality) \(subLocality)"
        
        return address
    }
    
    func fetchCurrentInformation(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                                 coordinate: Coordinate) async throws -> CurrentWeatherDTO {
        
        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .currentWeather, in: coordinate)
        
        guard let currentWeatherDTO = decodedData as? CurrentWeatherDTO else {
            throw NetworkError.failedTypeCasting
        }
        
        return currentWeatherDTO
    }
    
    func fetchCurrentImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                           currentWeatherDTO: CurrentWeatherDTO) async throws -> UIImage {
        
        guard let iconString = currentWeatherDTO.weather.first?.icon else {
            throw NetworkError.failedTypeCasting
        }
        let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
        guard let image = image else {
            throw NetworkError.failedTypeCasting
        }
        
        return image
    }
    
    func makeCurrentWeather(image: UIImage,
                            address: String,
                            currentWeatherDTO: CurrentWeatherDTO) -> CurrentWeather {
        
        let temperature = currentWeatherDTO.temperature
        let currentWeather = CurrentWeather(image: image, address: address, temperatures: temperature)
        return currentWeather
    }
}

