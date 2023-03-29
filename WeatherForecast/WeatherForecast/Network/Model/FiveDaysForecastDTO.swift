//
//  FiveDaysForecast.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

struct FiveDaysForecastDTO: Decodable {
    
    let list: [Day]
}

struct Day: Decodable {
    
    let time: String
    let temperature: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        
        case time = "dt_txt"
        case temperature = "main"
        case weather
    }
}

struct Temperature: Decodable {
    
    let currentTemperature, minimumTemperature, maximumTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        
        case currentTemperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}

struct Weather: Decodable {
//    let id: Double
//    let main, description
    let icon: String
}


