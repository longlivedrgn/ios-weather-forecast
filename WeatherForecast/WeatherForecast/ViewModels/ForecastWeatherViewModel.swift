//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/31.
//

import UIKit
import CoreLocation

final class ForecastWeatherViewModel {
    
    struct FiveDaysForecast: Identifiable {
        let id = UUID()
        var image: UIImage?
        let date: String
        let temperature: Double
    }
    
    private var weatherAPIManager: WeatherAPIManager?
    
    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)
    }
    
    func makeForecastWeather(coordinate: Coordinate, location: CLLocation, completion: @escaping (String, Day) -> Void) {
                
        self.weatherAPIManager?.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate) { data in
            
            guard let forecastData = data as? FiveDaysForecastDTO else { return }
            
            for eachData in forecastData.list {
                
                guard let icon = eachData.weather.first?.icon else { return }
                completion(icon, eachData)
            }
        }
    }
    
    func makeForecastImage(icon: String, eachData: Day) {
        
        self.weatherAPIManager?.fetchWeatherImage(icon: icon) { [weak self] image in
            
            let fiveDaysForecast = FiveDaysForecast(image: image, date: eachData.time, temperature: eachData.temperature.temperature)
            print(fiveDaysForecast)

        }
    }
}
