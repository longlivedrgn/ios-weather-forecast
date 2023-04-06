//
//  FiveDaysForecastWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class FiveDaysForecastWeatherViewModel {
    
    struct FiveDaysForecast: Identifiable {
        let id = UUID()
        var image: UIImage?
        let date: String
        let temperature: Double
    }
    
    func fetchForecastWeather(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                             coordinate: Coordinate,
                             location: CLLocation
    ) async throws -> FiveDaysForecastDTO {
        
        let data = try await weatherNetworkDispatcher.requestWeatherInformation(of: .fiveDaysForecast, in: coordinate)
        guard let forecastData = data as? FiveDaysForecastDTO else {
            throw NetworkError.failedTypeCasting
        }
        
        return forecastData
    }
    
    func fetchForecastImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                           fiveDaysForecastDTO: FiveDaysForecastDTO
    ) async throws -> [FiveDaysForecast] {
        
        var fiveDaysForecastArray: [FiveDaysForecast] = []
        
        for forecast in fiveDaysForecastDTO.list {
            
            guard let iconString = forecast.weather.first?.icon else {
                throw NetworkError.emptyData
            }
            let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
            let fiveDaysForecast = FiveDaysForecast(image: image, date: forecast.time, temperature: forecast.temperature.temperature)
            fiveDaysForecastArray.append(fiveDaysForecast)
        }
        
        return fiveDaysForecastArray
    }
}
