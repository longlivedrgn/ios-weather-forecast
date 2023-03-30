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

final class WeatherController {
    
    struct CurrentWeather: Identifiable {
        let id = UUID()
        
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    struct FiveDaysForecast: Identifiable {
        let id = UUID()
        
        var image: UIImage?
        let date: String
        let temperature: Double
    }
    
    private var weatherAPIManager: WeatherAPIManager?
    private let locationManager = LocationManager()
    
    weak var currentWeatherDelegate: CurrentWeatherDelegate?
    
    var currentWeather: CurrentWeather?
    var forecaseWeather: [FiveDaysForecast] = []
        
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
    
    private func makeCurrentWeather(location: CLLocation) {
        
        let coordinate = makeCoordinate(from: location)
        
        locationManager.changeGeocoder(location: location) { [weak self] place in
            
            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }
            
            let address = "\(locality) \(subLocality)"
            
            self?.weatherAPIManager?.fetchWeatherInformation(of: .currentWeather, in: coordinate) { [weak self] data in
                
                guard let weatherData = data as? CurrentWeatherDTO else { return }
                
                guard let icon = weatherData.weather.first?.icon else { return }
                
                self?.weatherAPIManager?.fetchWeatherImage(icon: icon) { [weak self] weatherImage in
                    
                    let currentWeatherData = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
                    
                    self?.currentWeather = currentWeatherData
                    self?.currentWeatherDelegate?.sendCurrent()
                }
            }
        }
    }
    
    private func makeForecastWeather(location: CLLocation) {
        
        let coordinate = self.makeCoordinate(from: location)
        
        self.weatherAPIManager?.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate) { data in
            
            guard let forecastData = data as? FiveDaysForecastDTO else { return }
            
            for eachData in forecastData.list {
                
                guard let icon = eachData.weather.first?.icon else { return }
                
                self.weatherAPIManager?.fetchWeatherImage(icon: icon) { image in
                    let test = FiveDaysForecast(image: image, date: eachData.time, temperature: eachData.temperature.temperature)
                    
                    self.forecaseWeather.append(test)
                    
                    if self.forecaseWeather.count == 40 {
                        self.currentWeatherDelegate?.sendForecast()
                    }
                }
            }
        }
    }
    
    func makeWeatherData(location: CLLocation) {
        makeCurrentWeather(location: location)
        makeForecastWeather(location: location)
    }

}

extension WeatherController: LocationDelegate {
    func send(location: CLLocation) {
        makeWeatherData(location: location)
    }
    
}
