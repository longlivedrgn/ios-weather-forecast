//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
    
    weak var delegate: CurrentWeatherViewModelDelegate?
    
    struct CurrentWeather {
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    func fetchCurrentAddress(locationManager: CoreLocationManager,
                            location: CLLocation) async throws -> String {
        let location = try await locationManager.changeGeocoder(location: location)
        guard let locality = location?.locality, let subLocality = location?.subLocality else { return "" }
        let address = "\(locality) \(subLocality)"
        return address
    }
    
    func fetchCurrentInformation(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                                coordinate: Coordinate) async throws -> (String, CurrentWeatherDTO) {
        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .currentWeather, in: coordinate)
        
        guard let weatherData = decodedData as? CurrentWeatherDTO else { throw NetworkError.failedDecoding }
        guard let icon = weatherData.weather.first?.icon else { throw NetworkError.failedRequest }
        
        return (icon, weatherData)
    }
    
    func fetchCurrentImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                           iconString: String
    ) async throws -> UIImage {
        let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
        guard let image = image else { throw NetworkError.emptyData }
        return image
    }
    
    func makeCurrentWeather(image: UIImage, address: String, temperatures: Temperature) -> CurrentWeather {
        let currentWeather = CurrentWeather(image: image, address: address, temperatures: temperatures)
        return currentWeather
    }
}

