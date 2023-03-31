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
    
    private let fiveDaysForecastWeatherViewModel = FiveDaysForecastWeatherViewModel()
    private let currentWeatherViewModel = CurrentWeatherViewModel()

    private let locationManager = CoreLocationManager()
    private let weatherAPIManager: WeatherAPIManager?
        
    var fiveDaysForecastWeather: [FiveDaysForecastWeatherViewModel.FiveDaysForecast] = []
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
        
    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)
        
        locationManager.locationDelegate = self
    }
    
    // MARK: func
    func makeCoordinate(from location: CLLocation) -> Coordinate {

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
    func makeWeatherData(locationManager: CoreLocationManager, weatherAPIManager: WeatherAPIManager?) {
        
        guard let location = locationManager.locationManager?.location else { return }
        let coordinate = self.makeCoordinate(from: location)

        currentWeatherViewModel.makeCurrentAddress(
            locationManager: locationManager,
            location: location
        ) { [weak self] address in

            self?.currentWeatherViewModel.makeCurrentInformation(
                weatherAPIManager: weatherAPIManager,
                coordinate: coordinate,
                location: location,
                address: address
            ) { [weak self] iconString, weatherData in
                
                self?.currentWeatherViewModel.makeCurrentImage(
                    weatherAPIManager: weatherAPIManager,
                    iconString: iconString,
                    address: address,
                    weatherData: weatherData
                )
            }
        }
        
        self.fiveDaysForecastWeatherViewModel.makeForecastWeather(
            weatherAPIManager: weatherAPIManager,
            coordinate: coordinate,
            location: location
        ) { [weak self] iconString, eachData in
            
            self?.fiveDaysForecastWeatherViewModel.makeForecastImage(
                weatherAPIManager: weatherAPIManager,
                icon: iconString,
                eachData: eachData
            )
        }
    }
}

extension WeatherViewModel: LocationDelegate {
    func didUpdateLocation() {
        makeWeatherData(
            locationManager: locationManager,
            weatherAPIManager: weatherAPIManager
        )
    }
}
