//
//  CurrentViewModel.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
    
    struct CurrentWeather: Identifiable {
        let id = UUID()
        
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    private var weatherAPIManager: WeatherAPIManager?
    
    var currentWeather: CurrentWeather?
    
    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)
    }
    
    func makeCurrentAddress(locationManager: LocationManager, location: CLLocation, completion: @escaping (String) -> Void) {
        
        locationManager.changeGeocoder(location: location) { place in
            
            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }
            let address = "\(locality) \(subLocality)"
            completion(address)
        }
    }
    
    func makeCurrentInformation(coordinate: Coordinate, location: CLLocation, address: String, completion: @escaping (String, CurrentWeatherDTO) -> Void) {
                
        self.weatherAPIManager?.fetchWeatherInformation(of: .currentWeather, in: coordinate) { data in
            
            guard let weatherData = data as? CurrentWeatherDTO else { return }
            guard let icon = weatherData.weather.first?.icon else { return }
            
            completion(icon, weatherData)
        }
    }
    
    func makeCurrentImage(icon: String, address: String, weatherData: CurrentWeatherDTO) {
        
        self.weatherAPIManager?.fetchWeatherImage(icon: icon) { [weak self] weatherImage in
            
            let currentWeatherData = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
            print(currentWeatherData)
        }
    }
}
