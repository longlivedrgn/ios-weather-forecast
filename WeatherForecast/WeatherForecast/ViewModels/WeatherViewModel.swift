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
    
    private let locationManager = CoreLocationManager()
    private let weatherAPIManager: WeatherAPIManager?
    
    weak var weatherDataDelegate: WeatherDataDelegate?
    
    var currentWeather: CurrentWeatherViewModel.CurrentWeather? {
        didSet {
            weatherDataDelegate?.sendCurrentWeather()
        }
    }
    var fiveDaysForecastWeather: [FiveDaysForecastWeatherViewModel.FiveDaysForecast] = [
        FiveDaysForecastWeatherViewModel.FiveDaysForecast(date: "test", temperature: 20),
        FiveDaysForecastWeatherViewModel.FiveDaysForecast(date: "test2", temperature: 25)
    ] {
        didSet {
            weatherDataDelegate?.sendForecast()
        }
    }
    
    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)
        
        locationManager.locationDelegate = self
    }
    
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
                ) { currentData in
                    self?.currentWeather = currentData
                }
            }
        }
        
        var forecastData: [FiveDaysForecastWeatherViewModel.FiveDaysForecast] = []
        let group1 = DispatchGroup()
        
        self.fiveDaysForecastWeatherViewModel.makeForecastWeather(
            weatherAPIManager: weatherAPIManager,
            coordinate: coordinate,
            location: location
        ) { [weak self] iconString, eachData in
            group1.enter()
            self?.fiveDaysForecastWeatherViewModel.makeForecastImage(
                weatherAPIManager: weatherAPIManager,
                icon: iconString,
                eachData: eachData
            ) { forecast in
                forecastData.append(forecast)
                
                group1.leave()
            }
            
        }
        group1.wait()
        group1.notify(queue: .main) {
            print(forecastData)
        }
        
    }
    
    func forecast(with id: UUID) -> FiveDaysForecastWeatherViewModel.FiveDaysForecast? {
        return fiveDaysForecastWeather.first(where: { $0.id == id })
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
