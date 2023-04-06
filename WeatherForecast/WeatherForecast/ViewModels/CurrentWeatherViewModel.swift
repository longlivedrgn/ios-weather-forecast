//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

enum LocationError: Error {
    case failedGetLocation
}

final class CurrentWeatherViewModel {
    
    struct CurrentWeather: Identifiable {
        let id = UUID()
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    func fetchCurrentAddress(locationManager: CoreLocationManager,
                            location: CLLocation
    ) async throws -> String {
        
        let firstLocation = try await locationManager.changeGeocoder(location: location)
        guard let locality = firstLocation?.locality, let subLocality = firstLocation?.subLocality else {
            // MARK: - location Error
            throw LocationError.failedGetLocation
        }
        let address = "\(locality) \(subLocality)"
        
        return address
    }
    
    func fetchCurrentInformation(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                                coordinate: Coordinate,
                                location: CLLocation
    ) async throws -> CurrentWeatherDTO {
        
        let data = try await weatherNetworkDispatcher.requestWeatherInformation(of: .currentWeather, in: coordinate)
        guard let weatherData = data as? CurrentWeatherDTO else {
            throw NetworkError.failedTypeCasting
        }
        
        return weatherData
    }
    
    func fetchCurrentImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                          address: String,
                          currentWeatherDTO: CurrentWeatherDTO
    ) async throws -> CurrentWeather {
        
        guard let iconString = currentWeatherDTO.weather.first?.icon else {
            throw NetworkError.emptyData
        }
        let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
        let currentWeather = CurrentWeather(image: image, address: address, temperatures: currentWeatherDTO.temperature)
        
        return currentWeather
    }
}

