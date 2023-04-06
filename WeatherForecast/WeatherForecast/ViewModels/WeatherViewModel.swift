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
        currentWeatherViewModel.delegate = self
        fiveDaysForecastWeatherViewModel.delegate = self
    }
    
    private func makeCoordinate(from location: CLLocation) -> Coordinate {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
    func execute(locationManager: CoreLocationManager, location: CLLocation, weatherNetworkDispatcher: WeatherNetworkDispatcher) {
        
        let coordinate = self.makeCoordinate(from: location)
        
        Task {
            let address = try await currentWeatherViewModel.fetchCurrentAddress(locationManager: coreLocationManager, location: location)
            let (iconString, weatherData) = try await currentWeatherViewModel.fetchCurrentInformation(weatherNetworkDispatcher: weatherNetworkDispatcher, coordinate: coordinate)
            let currentWeatherImage = try await currentWeatherViewModel.fetchCurrentImage(weatherNetworkDispatcher: weatherNetworkDispatcher, iconString: iconString)
            currentWeather = currentWeatherViewModel.makeCurrentWeather(image: currentWeatherImage, address: address, temperatures: weatherData.temperature)
            print(currentWeather)
            
            let fiveDaysForecastWeatherDTO = try await fiveDaysForecastWeatherViewModel.fetchForecastWeather(weatherNetworkDispatcher: weatherNetworkDispatcher, coordinate: coordinate)
            
            for day in fiveDaysForecastWeatherDTO.list {
                guard let iconString = day.weather.first?.icon else { return }
                let fiveDaysForecastImage = try await fiveDaysForecastWeatherViewModel.fetchForecastImage(weatherNetworkDispatcher: weatherNetworkDispatcher, iconString: iconString)
                let fiveDaysForecast = fiveDaysForecastWeatherViewModel.makeFiveDaysForecast(image: fiveDaysForecastImage, day: day)
                fiveDaysForecastWeather.append(fiveDaysForecast)
                print(fiveDaysForecast)
            }
            delegate?.weatherViewModelDidFinishSetUp(self)
            
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

extension WeatherViewModel: CurrentWeatherViewModelDelegate {
    func currentWeatherViewModel(_ viewModel: CurrentWeatherViewModel, didCreateModelObject currentWeather: CurrentWeatherViewModel.CurrentWeather) {
        self.currentWeather = currentWeather
    }
}

extension WeatherViewModel: FiveDaysForecastWeatherViewModelDelegate {
    func fiveDaysForecastWeatherViewModel(_ viewModel: FiveDaysForecastWeatherViewModel, didCreateModelObject fiveDaysForecastWeather: FiveDaysForecastWeatherViewModel.FiveDaysForecast) {
        self.fiveDaysForecastWeather.append(fiveDaysForecastWeather)
    }
}
