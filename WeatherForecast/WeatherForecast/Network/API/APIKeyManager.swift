//
//  APIKeyManager.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import UIKit

enum APIKeyManager {
    case openWeather
    
    var apiKey: String {
        switch self {
        case .openWeather:
            return APIKeys.openWeatherKey
        }
    }
}
