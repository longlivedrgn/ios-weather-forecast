//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import UIKit

enum WeatherAPI: String {
    
    case currentWeather
    case fiveDaysForecast
    
    var decodingType: Decodable.Type {
        
        switch self {
        case .currentWeather:
            return CurrentWeatherDTO.self
        case .fiveDaysForecast:
            return FiveDaysForecastDTO.self
        }
    }
}

// 가변 매개변수, urlcomponent -> urlrequest

extension WeatherAPI {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let baseImageURL = "https://openweathermap.org"
    
    var path: String {
        
        // MARK: baseURL 과 path 변경
        switch self {
        case .currentWeather:
            return "weather?"
        case .fiveDaysForecast:
            return "forecast?"
        }
    }
    
    // method 선택, 쿼리 붙이는 메서드
    // endpoint
    
    func makeWeatherURL(coordinate: Coordinate) -> URL {
        
        let queryItems = "\(coordinate.description)&units=metric&appid="
        let apiKey = APIKeyManager.openWeather.apiKey
        
        return URL(string: WeatherAPI.baseURL + self.path + queryItems + apiKey)!
    }
    
    static func makeImageURL(icon: String) -> URL {
        
        let path = "/img/wn/\(icon)@2x.png"
        
        return URL(string: WeatherAPI.baseImageURL + path)!
    }
}
