//
//  CurrentWeatherViewModelDelegate.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/05.
//

import Foundation

protocol CurrentWeatherViewModelDelegate: AnyObject {
    func currentWeatherViewModel(_ viewModel: CurrentWeatherViewModel,
                                 didCreateModelObject currentWeather: CurrentWeatherViewModel.CurrentWeather)
}
