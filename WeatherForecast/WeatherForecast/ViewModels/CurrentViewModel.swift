//
//  CurrentViewModel.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentViewModel {
    
    struct CurrentWeather: Identifiable {
        let id = UUID()
        
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    private let locationManager = LocationManager()
    private var weatherAPIManager: WeatherAPIManager?
    private let weatherViewModel = WeatherViewModel()
    
    var currentWeather: CurrentWeather?
    
    
    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)
    }

    
    // solid : "S"!!!!!
    // 네이밍
    func makeCurrentAddress(location: CLLocation, completion: @escaping (String) -> Void) {
        
        locationManager.changeGeocoder(location: location) { place in
            
            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }
            let address = "\(locality) \(subLocality)"
            completion(address)
        }
    }
    
    func makeCurrentInformation(location: CLLocation, address: String, completion: @escaping (String, CurrentWeatherDTO) -> Void) {
        
        let coordinate = weatherViewModel.makeCoordinate(from: location)
        
        self.weatherAPIManager?.fetchWeatherInformation(of: .currentWeather, in: coordinate) { data in
            
            guard let weatherData = data as? CurrentWeatherDTO else { return }
            guard let icon = weatherData.weather.first?.icon else { return }
            
            completion(icon, weatherData)
        }
    }
    
    func makeCurrentImage(icon: String, address: String, weatherData: CurrentWeatherDTO) {
        
        self.weatherAPIManager?.fetchWeatherImage(icon: icon) { [weak self] weatherImage in
            
            let currentWeatherData = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
            
            self?.currentWeather = currentWeatherData
//            self?.weatherDelegate?.sendCurrent()
        }
    }
}
