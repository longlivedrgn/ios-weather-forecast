//
//  Protocol.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/29.
//

import Foundation
import CoreLocation

protocol LocationDelegate: AnyObject {
    func didUpdateLocation()
}

protocol CurrentWeatherViewModelDelegate: AnyObject {
    func send(_ currentWeather: CurrentWeatherViewModel.CurrentWeather)
}

protocol FiveForecastDayWeatherViewModelDelegate: AnyObject {
    func send(_ fiveDaysForecastWeather: FiveDaysForecastWeatherViewModel.FiveDaysForecast)
}
 
