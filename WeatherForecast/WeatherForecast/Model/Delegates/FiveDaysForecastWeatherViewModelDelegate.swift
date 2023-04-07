//
//  FiveDaysForecastWeatherViewModelDelegate.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/05.
//

import Foundation

protocol FiveDaysForecastWeatherViewModelDelegate: AnyObject {
    func fiveDaysForecastWeatherViewModel(_ viewModel: FiveDaysForecastWeatherViewModel,
                                          didCreateModelObject fiveDaysForecastWeather: FiveDaysForecastWeatherViewModel.FiveDaysForecast)
}
