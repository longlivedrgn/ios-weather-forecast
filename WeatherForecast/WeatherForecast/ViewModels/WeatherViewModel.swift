//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/31.
//

import UIKit
import CoreLocation

final class WeatherViewModel {
    
    private let fiveDaysForecastWeatherViewModel = FiveDaysForecastWeatherViewModel()
    private let currentWeatherViewModel = CurrentWeatherViewModel()
    
    private let coreLocationManager = CoreLocationManager()
    private let weatherNetworkDispatcher: WeatherNetworkDispatcher
    
    weak var delegate: WeatherViewModelDelegate?
    
    var fiveDaysForecastWeather: [FiveDaysForecastWeatherViewModel.FiveDaysForecast] = []
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
    
    init(networkSession: NetworkSession = NetworkSession(session: URLSession.shared)) {
        weatherNetworkDispatcher = WeatherNetworkDispatcher(networkSession: networkSession)
        coreLocationManager.delegate = self
    }
    
    private func makeCoordinate(from location: CLLocation) -> Coordinate {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
    private func execute(locationManager: CoreLocationManager,
                 location: CLLocation,
                 weatherNetworkDispatcher: WeatherNetworkDispatcher) {
        
        let coordinate = self.makeCoordinate(from: location)
        
        Task {
            let address = try await currentWeatherViewModel.fetchCurrentAddress(
                locationManager: coreLocationManager,
                location: location)
            
            let currentWeatherDTO = try await currentWeatherViewModel.fetchCurrentInformation(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate
            )
            
            let currentWeatherImage = try await currentWeatherViewModel.fetchCurrentImage(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                currentWeatherDTO: currentWeatherDTO
            )
            
            let currentWeather = currentWeatherViewModel.makeCurrentWeather(
                image: currentWeatherImage,
                address: address,
                currentWeatherDTO: currentWeatherDTO
            )
            
            self.currentWeather = currentWeather
            
            let fiveDaysForecastWeatherDTO = try await fiveDaysForecastWeatherViewModel.fetchForecastWeather(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate
            )
            
            let fiveDaysForecastImages = try await fiveDaysForecastWeatherViewModel.fetchForecastImages(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                fiveDaysForecastDTO: fiveDaysForecastWeatherDTO
            )
            
            let fiveDaysForecasts = fiveDaysForecastWeatherViewModel.makeFiveDaysForecast(
                images: fiveDaysForecastImages,
                fiveDaysForecastDTO: fiveDaysForecastWeatherDTO
            )
            
            self.fiveDaysForecastWeather = fiveDaysForecasts
            
            DispatchQueue.main.async {
                self.delegate?.weatherViewModelDidFinishSetUp(self)
            }
        }
    }
    
    func receiveDataFromAlertController(_ coordinate: Coordinate) {
        print("WeatherViewModel: \(coordinate)")
        
        execute(locationManager: coreLocationManager, location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), weatherNetworkDispatcher: weatherNetworkDispatcher)
//        execute(locationManager: coreLocationManager, location: CLLocation(latitude: 37.486082, longitude: 127.121675), weatherNetworkDispatcher: weatherNetworkDispatcher)
    }
}

extension WeatherViewModel: CoreLocationManagerDelegate {
    
    func coreLocationManager(_ manager: CoreLocationManager,
                             didUpdateLocation location: CLLocation) {
        execute(
            locationManager: manager,
            location: location,
            weatherNetworkDispatcher: weatherNetworkDispatcher
        )
    }
}
