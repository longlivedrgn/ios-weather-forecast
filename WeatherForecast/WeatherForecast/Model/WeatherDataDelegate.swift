//
//  WeatherDataDelegate.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/04/02.
//

import Foundation

protocol WeatherDataDelegate: AnyObject {
    func sendCurrentWeather()
    func sendForecast()
}
