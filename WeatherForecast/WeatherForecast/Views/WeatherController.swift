//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/24.
//

import UIKit
import CoreLocation

class WeatherController {
    
    private let weatherAPIManager = WeatherAPIManager(networkModel: NetworkModel())
    private let locationDelegate = LocationManagerDelegate()
    lazy var coreLocationManger: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    init() {
        coreLocationManger.delegate = locationDelegate
    }
    
    struct CurrentWeather {
        let image: UIImage
        let address: String
        let temperatures: Temperature
    }
    
    struct FiveDaysForecast {
        let image: UIImage
        let date: String
        let temperature: Double
    }
    
    lazy var currentWeathers: CurrentWeather? = {
        return generateCurrentWeather()
    }()
    
    lazy var fiveDaysForcasts: [FiveDaysForecast]? = {
        return generateFiveDaysForcasts()
    }()
}

extension WeatherController {
    func generateCurrentWeather() -> CurrentWeather? {
        // MARK: - 함수 분리하기!
        let location = locationDelegate.coordinate
        let coordinate = location.coordinate
        let longitude = coordinate.longitude
        let latitude = coordinate.latitude
        let weather = weatherAPIManager.fetchWeatherInformation(of: WeatherAPI.currentWeather, in: Coordinate(longitude: longitude, latitude: latitude))
        guard let weather = weather as? CurrentWeatherDTO else { return nil }
        let temperature = weather.temperature
        let iconString = weather.weather[0].icon
        guard let imageData = weatherAPIManager.fetchImage(icon: iconString) else { return nil}
        let image = UIImage(data: imageData)!
        let address = locationDelegate.address
        let result = CurrentWeather(image: image, address: address, temperatures: temperature)
        return result
    }
    
    func generateFiveDaysForcasts() -> [FiveDaysForecast]? {
        let location = locationDelegate.coordinate
        let coordinate = location.coordinate
        let longitude = coordinate.longitude
        let latitude = coordinate.latitude
        let weather = weatherAPIManager.fetchWeatherInformation(of: WeatherAPI.fiveDaysForecast, in: Coordinate(longitude: longitude, latitude: latitude))
        guard let weather = weather as? FiveDaysForecastDTO else { return nil }
        var forcastWeathers = [FiveDaysForecast]()
        var iconStrings = [String]()
        var times = [String]()
        var temperatures = [Double]()
        let list = weather.list
        list.forEach { day in
            iconStrings.append(day.weather[0].icon)
            times.append(day.time)
            temperatures.append(day.temperature.temperature)
            return
        }
        for (index, iconString) in iconStrings.enumerated() {
            guard let imageData = weatherAPIManager.fetchImage(icon: iconString) else { return nil }
            let image = UIImage(data: imageData)!
            let forcastWeather = FiveDaysForecast(image: image, date: times[index], temperature: temperatures[index])
            forcastWeathers.append(forcastWeather)
        }
        return forcastWeathers
    }
}
