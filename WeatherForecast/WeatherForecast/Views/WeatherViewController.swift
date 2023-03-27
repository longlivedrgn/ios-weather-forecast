//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    private var weatherController = WeatherController()

    @IBAction func buttonTapped(_ sender: Any) {
        print(weatherController.currentWeathers?.address)
        guard let forcasts = weatherController.fiveDaysForcasts else { return print("asdf")}
        print(forcasts[0].temperature)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

