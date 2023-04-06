//
//  FiveDaysForecastWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class FiveDaysForecastWeatherViewModel {
    
    weak var delegate: FiveDaysForecastWeatherViewModelDelegate?
    
    struct FiveDaysForecast {
        var image: UIImage?
        let date: String
        let temperature: Double
    }
    func fetchForecastWeather(weatherNetworkDispatcher: WeatherNetworkDispatcher, coordinate: Coordinate
    ) async throws -> FiveDaysForecastDTO {
        
        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .fiveDaysForecast, in: coordinate)
        
        guard let weatherData = decodedData as? FiveDaysForecastDTO else {
            throw NetworkError.failedDecoding
        }
        
        return weatherData
    }
    
    func fetchForecastImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                            iconString: String) async throws -> UIImage {
        let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
        guard let image = image else {
            throw NetworkError.emptyData }
        return image
    }
    
    func makeFiveDaysForecast(image: UIImage, day: Day) -> FiveDaysForecast {
        let date = day.time
        let temperature = day.temperature.averageTemperature
        let fiveDaysForecastWeather = FiveDaysForecast(image: image, date: date, temperature: temperature)
        
        return fiveDaysForecastWeather
    }
}
