//
//  FiveDaysForecastWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class FiveDaysForecastWeatherViewModel {
    
//    weak var delegate: FiveDaysForecastWeatherViewModelDelegate?
    
    struct FiveDaysForecast {
        var image: UIImage?
        let date: String
        let temperature: Double
    }
    
    func fetchForecastWeather(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                              coordinate: Coordinate) async throws -> FiveDaysForecastDTO {
        
        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .fiveDaysForecast, in: coordinate)
        
        guard let fiveDaysForecastDTO = decodedData as? FiveDaysForecastDTO else {
            throw NetworkError.failedTypeCasting
        }
        
        return fiveDaysForecastDTO
    }
    func fetchForecastImages(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                             fiveDaysForecastDTO: FiveDaysForecastDTO) async throws -> [UIImage] {
        
        var images: [UIImage] = []
        
        for day in fiveDaysForecastDTO.list {
            guard let iconString = day.weather.first?.icon else {
                throw NetworkError.failedTypeCasting
            }
            
            let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
            
            guard let image = image else {
                throw NetworkError.failedTypeCasting
            }
            
            images.append(image)
        }
        
        return images
    }
    
    func makeFiveDaysForecast(images: [UIImage],
                              fiveDaysForecastDTO: FiveDaysForecastDTO) -> [FiveDaysForecast] {
        
        var fiveDaysForecast: [FiveDaysForecast] = []
        
        for (index, day) in fiveDaysForecastDTO.list.enumerated() {
            let date = day.time
            let temeperature = day.temperature.averageTemperature
            let fiveDaysForecastWeather = FiveDaysForecast(image: images[index], date: date, temperature: temeperature)
            
            fiveDaysForecast.append(fiveDaysForecastWeather)
        }
        
        return fiveDaysForecast
    }
}
