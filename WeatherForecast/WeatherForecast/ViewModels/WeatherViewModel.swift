//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/24.
//

/*
 - 연달아서 사용한 completionHandler 코드 대신 aync/await 코드 리팩토링
 */

import UIKit
import CoreLocation

final class WeatherViewModel {
    
    private var forecastWeatherViewModel = ForecastWeatherViewModel()
    lazy var currentWeatherViewModel = CurrentWeatherViewModel()
    
    weak var weatherDelegate: WeatherDelegate?
    lazy var locationManager = LocationManager()
    
    var forecaseWeather: [ForecastWeatherViewModel.FiveDaysForecast] = []
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
        
    init() {
        locationManager.locationDelegate = self
    }
    
    // MARK: func
    func makeCoordinate(from location: CLLocation) -> Coordinate {

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    

    
    func makeWeatherData(locationManager: LocationManager, location: CLLocation) {
        
        let coordinate = self.makeCoordinate(from: location)

        currentWeatherViewModel.makeCurrentAddress(locationManager: locationManager, location: location) { [weak self] address in

            self?.currentWeatherViewModel.makeCurrentInformation(coordinate: coordinate, location: location, address: address) { [weak self] iconString, weatherData in
                self?.currentWeatherViewModel.makeCurrentImage(icon: iconString, address: address, weatherData: weatherData)
            }
        }
        
        forecastWeatherViewModel.makeForecastWeather(coordinate: coordinate, location: location) { [weak self] iconString, eachData in
            
            self?.forecastWeatherViewModel.makeForecastImage(icon: iconString, eachData: eachData)
        }
    }
}

extension WeatherViewModel: LocationDelegate {
    func send(location: CLLocation) {
        makeWeatherData(locationManager: locationManager, location: location)
    }
}
