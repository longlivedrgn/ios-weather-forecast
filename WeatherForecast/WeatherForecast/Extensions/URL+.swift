//
//  URL+.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import UIKit

//extension URL {
//    static func makeOpenWeatherURL(of weatherAPI: WeatherAPI, coordinate: Coordinate, key: String) -> URL {
//        let baseURL = "https://api.openweathermap.org/data/2.5/"
//        let lastURL = "?\(coordinate.description)&units=metric&appid=\(key)"
//        return URL(string: baseURL + weatherAPI.urlComponent + lastURL)!
//    }
//}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "lat=\(latitude)&lon=\(longitude)"
    }
}
