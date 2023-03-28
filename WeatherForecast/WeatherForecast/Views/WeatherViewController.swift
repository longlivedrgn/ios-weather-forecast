//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    
    private var weatherController = WeatherController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherController.currentWeather?.bind({ currentWeather in
            // 업데이트
        })
    }
    
}

