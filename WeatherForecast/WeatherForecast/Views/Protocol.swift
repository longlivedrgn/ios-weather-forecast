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

protocol WeatherDelegate: AnyObject {
    func sendCurrent()
    func sendForecast()
}
