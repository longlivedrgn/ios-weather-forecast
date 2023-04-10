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
        NotificationCenter.default.addObserver(self, selector: #selector(changeLocation(notification:)), name: Notification.Name("currentWeatherHeaderView"), object: nil)
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
        print(coordinate)
        Task {
            let address = try await currentWeatherViewModel.fetchCurrentAddress(
                locationManager: coreLocationManager,
                location: location)
            print(address)
            let currentWeatherDTO = try await currentWeatherViewModel.fetchCurrentInformation(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate
            )
            print("WHat?..")
            print(currentWeatherDTO)
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
    
    @objc func changeLocation(notification: Notification) {
        guard let location = notification.userInfo?["ChangedLocation"] as? CLLocation else { return }
        execute(locationManager: coreLocationManager, location: location, weatherNetworkDispatcher: weatherNetworkDispatcher)
    }
}
