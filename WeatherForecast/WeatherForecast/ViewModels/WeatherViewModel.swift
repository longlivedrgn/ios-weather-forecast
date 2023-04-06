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
    
    func execute(locationManager: CoreLocationManager, location: CLLocation, weatherNetworkDispatcher: WeatherNetworkDispatcher) {
        
        let coordinate = self.makeCoordinate(from: location)
        
        Task {
            let address = try await self.currentWeatherViewModel.fetchCurrentAddress(
                locationManager: locationManager,
                location: location
            )
            
            let currentWeatherDTO = try await self.currentWeatherViewModel.fetchCurrentInformation(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate,
                location: location
            )
            let currentWeather = try await self.currentWeatherViewModel.fetchCurrentImage(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                address: address,
                currentWeatherDTO: currentWeatherDTO
            )
            self.currentWeather = currentWeather
            print("여긴 WeatherViewModel: \(self.currentWeather)")
        }
        
        Task {
            let fiveDaysForecastDTO = try await self.fiveDaysForecastWeatherViewModel.fetchForecastWeather(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate,
                location: location
            )
            let fiveDaysForecast =  try await self.fiveDaysForecastWeatherViewModel.fetchForecastImage(
                weatherNetworkDispatcher: weatherNetworkDispatcher, fiveDaysForecastDTO: fiveDaysForecastDTO
            )
            self.fiveDaysForecastWeather = fiveDaysForecast
            print("여긴 WeatherViewModel: \(self.fiveDaysForecastWeather)")
        }
    }
}

extension WeatherViewModel: CoreLocationManagerDelegate {
    func coreLocationManager(_ manager: CoreLocationManager, didUpdateLocation location: CLLocation) {
        execute(
            locationManager: manager,
            location: location,
            weatherNetworkDispatcher: weatherNetworkDispatcher
        )
    }
}
