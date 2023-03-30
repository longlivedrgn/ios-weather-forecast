//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import Foundation

struct CurrentWeatherDTO: Decodable {
    
    let temperature: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        
        case temperature = "main"
        case weather
    }
}

struct Coordinate: Decodable {
    
    let longitude: Double
    let latitude: Double
}

extension Coordinate: CustomStringConvertible {
    
    var description: String {
        
        return "lat=\(latitude)&lon=\(longitude)"
    }
}

