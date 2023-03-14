//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

class NetworkManager {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) {
        
        let url1 = WeatherAPI.currentWeather.makeOpenWeatherURL(coordinate: coordinate, key: APIKeyManager.openWeather.apiKey)
        let url2 = URL.makeOpenWeatherURL(of: .currentWeather, coordinate: coordinate, key: APIKeyManager.openWeather.apiKey)
        
        
        print(url)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print("error1")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("error2")
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherInSeoul = try decoder.decode(CurrentWeather.self, from: data)
                    print(weatherInSeoul.coordinate.description)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
