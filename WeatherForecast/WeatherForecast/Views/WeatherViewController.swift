//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    
    private var weatherController = WeatherController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherController.currentWeatherDelegate = self
        weatherController.fiveDaysForecastDelegate = self
    }
    
}

extension WeatherViewController: CurrentWeatherDelegate {
    
    func notifyToUpdateCurrentWeather() {
        // apply snapshot!
        print(weatherController.currentWeather)
    }
}

extension WeatherViewController: FiveDaysForecastDelegate {
    
    func notifyToUpdateFiveDaysForecast() {
        guard let array = weatherController.fiveForecast else { return }
        for i in array {
            print(i)
        }
    }
}

