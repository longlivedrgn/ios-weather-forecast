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

//extension Coordinate: CustomStringConvertible {
//    var description: String {
//        return "lat=\(latitude)&lon=\(longitude)"
//    }
//}
typealias NetworkResult = Result<Void, NetworkError>

extension URLResponse {
    
    fileprivate var successRange: ClosedRange<Int> {
        return 200...299
    }
    
    func checkResponse() -> NetworkResult {
        guard let httpResponse = self as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            return NetworkError.outOfStatuscode.resultOfNetworkError()
        }
        return Result.success(())
    }
}

enum NetworkError: Error {
    case failedRequest
    case outOfStatuscode
}

extension NetworkError {
    func resultOfNetworkError() -> NetworkResult {
        switch self {
        case .failedRequest:
            print("failed request")
            return NetworkResult.failure(self)
        case .outOfStatuscode:
            print("out of statuscode")
            return NetworkResult.failure(self)
        }
    }
}
