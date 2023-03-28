//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/24.
//

import UIKit
import CoreLocation

final class WeatherController {
    
    init() {
        locationManager.locationDelegate = self
    }
    
    struct CurrentWeather {
        let image: UIImage?
        let address: String?
        let temperatures: Temperature
    }
    
    struct FiveDaysForecast {
        let image: UIImage
        let date: String
        let temperature: Double
    }
    
    private let networkModel = NetworkModel()
    private let weatherAPIManager = WeatherAPIManager(networkModel: NetworkModel(session: URLSession.shared))
    private let locationManager = LocationManager()
    
    var currentWeather: CurrentWeather? {
        didSet {
            // 클로저 실행
        }
    }
//    var currentWeather: Box<CurrentWeather>?
    
    func makeCoordinate(from location: CLLocation) -> Coordinate {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
//    func makeCurrentWeather(location: CLLocation) {
//
//        var address: String?
//        var currentWeatherDTO: CurrentWeatherDTO?
//        var weatherImage: UIImage?
//
//        let coordinate = self.makeCoordinate(from: location)
//
//        let group = DispatchGroup()
//
//        group.enter()
//        locationManager.changeGeocoder(location: location) { place in
//
//            print("비동기 테스트 안 1")
//
////            print(place?.locality)
////            print(place?.subLocality)
////            address = "\(place?.locality) \(place?.subLocality)"
//            address = place?.description
//            group.leave()
//        }
//
//        group.notify(queue: .main) {
//            print("비동기 테스트 밖 1")
//            print(address)
//        }
//
//        group.enter()
//        self.weatherAPIManager.fetchWeatherInformation(of: .currentWeather, in: coordinate) { weatherData in
//
//            print("비동기 테스트 안 2")
//
//            guard let data = weatherData as? CurrentWeatherDTO else {
//                print("hey?")
//                return
//            }
//            currentWeatherDTO = data
//            group.leave()
//        }
//
////        guard let imageIcon = currentWeatherDTO?.weather.first?.icon else {
////            return
////        }
//        group.notify(queue: .main) {
//            print("비동기 테스트 밖 2")
//            print(currentWeatherDTO)
//        }
//
////        self.weatherAPIManager.fetchWeatherImage(icon: imageIcon) { image in
////
////            print("비동기 테스트 안 3")
////            weatherImage = image
////        }
//
//        group.enter()
//        self.weatherAPIManager.fetchWeatherImage(icon: "03d") { image in
//
//            print("비동기 테스트 안 3")
//            weatherImage = image
//            group.leave()
//        }
//
//        group.notify(queue: .main) {
//            print("비동기 테스트 밖 3")
//            guard let currentWeatherDTO = currentWeatherDTO else { return }
//
//            let currentWeatherData = CurrentWeather(image: weatherImage, address: address, temperatures: currentWeatherDTO.temperature)
//            self.currentWeather = currentWeatherData
//
//            print(self.currentWeather)
//        }
//    }
    
    func makeCurrentWeather(location: CLLocation) {
        
//        var address: String?
//        var currentWeatherDTO: CurrentWeatherDTO?
//        var weatherImage: UIImage?
        
        let coordinate = self.makeCoordinate(from: location)
        print(coordinate)
        
        Task {
            // 1. address
            let place = try? await self.locationManager.changeGeocoder(location: location)
            let address = place?.description
            print(address)
            
            // 2. currentWeatherDTO
            guard let weatherData = weatherAPIManager.fetchWeatherInformation(of: .currentWeather, in: coordinate) as? CurrentWeatherDTO else { return }
            print(weatherData)
            
            // 3. image
            guard let icon = weatherData.weather.first?.icon else { return }
            let image = weatherAPIManager.fetchWeatherImage(icon: icon)
            print(image)
            
            // 4. currentWeather
            let currentWeatherData = CurrentWeather(image: image, address: address, temperatures: weatherData.temperature)
            self.currentWeather = currentWeatherData
            print(self.currentWeather)
        }
        
        print("hey : \(self.currentWeather)")
    }
}


extension WeatherController: locationDelegate {
    func send(location: CLLocation) {
        makeCurrentWeather(location: location)
    }
}

final class Box<Value> {
    var value: Value {
        didSet {
            action?(value)
        }
    }
    
    init(value: Value) {
        self.value = value
    }
    
    var action: ((Value) -> Void)?
    
    func bind(_ action: @escaping (Value) -> Void) {
        self.action = action
    }
}
