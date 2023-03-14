//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import UIKit

enum WeatherAPI {
    
    case currentWeather
    case fiveDaysForecast
    
    var urlComponent: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .fiveDaysForecast:
            return "forecast"
        }
    }
   
}

extension WeatherAPI {
    func makeOpenWeatherURL(coordinate: Coordinate, key: String) -> URL {
        
        let baseURL = "https://api.openweathermap.org/data/2.5/"
        let lastURL = "?\(coordinate.description)&units=metric&appid=\(key)"
        return URL(string: baseURL + self.urlComponent + lastURL)!
    }
}
