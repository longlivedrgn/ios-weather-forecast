//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/31.
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
    
    func makeForecastWeather(weatherAPIManager: WeatherAPIManager?,
                             coordinate: Coordinate,
                             location: CLLocation,
                             completion: @escaping (String, Day) -> Void
    ) {
        weatherAPIManager?.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate) { data in
            
            guard let forecastData = data as? FiveDaysForecastDTO else { return }
            
            for eachData in forecastData.list {
            
                guard let icon = eachData.weather.first?.icon else { return }
                completion(icon, eachData)
            }
        }
    }
    
    func makeForecastImage(weatherAPIManager: WeatherAPIManager?,
                           icon: String,
                           eachData: Day
    ) {
        weatherAPIManager?.fetchWeatherImage(icon: icon) { image in
            
            let fiveDaysForecast = FiveDaysForecast(image: image, date: eachData.time, temperature: eachData.temperature.temperature)
            print(fiveDaysForecast)

        }
    }
}
