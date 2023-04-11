//
//  Double+.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/04/11.
//

import Foundation

extension Double {
    
    func changeWeatherFormat() -> String {
        return String(format: "%.1f", self)
    }
}
