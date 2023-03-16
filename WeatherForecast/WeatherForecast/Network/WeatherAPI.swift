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
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
}

// PR 질문
extension WeatherAPI {
    
    func makeWeatherURL(coordinate: Coordinate) -> URL {
        let lastURL = "?\(coordinate.description)&units=metric&appid="
        let apiKey = APIKeyManager.openWeather.apiKey
        
        return URL(string: WeatherAPI.baseURL + lastURL + apiKey)!
    }
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "lat=\(latitude)&lon=\(longitude)"
    }
}
