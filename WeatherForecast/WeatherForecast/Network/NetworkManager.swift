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
        let url = WeatherAPI.currentWeather.makeWeatherURL(coordinate: coordinate)
        let request = URLRequest(url: url)
        
        let task2 = makeTask(session: session, request: request) { error, response, data in
            self.handlingError(error: error)
            self.handlingResponse(response: response, data: data)
        }
        task2.resume()
    }
    
    func handlingResponse(response: URLResponse?, data: Data?) {
        switch response?.checkResponse() {
        case .failure(let error):
            print(error)
        case .success():
            guard let result = self.decode(from: data, to: CurrentWeather.self) else { return }
            print("결과야 \(result)")
        case .none:
            break
        }
    }
    
    func handlingError(error: Error?) {
        guard error == nil else {
            print(NetworkError.failedRequest.resultOfNetworkError())
            return
        }
    }
    
    func makeTask(session: URLSession, request: URLRequest, closure: @escaping (Error?, URLResponse?, Data?) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: request) { data, response, error in
            closure(error, response, data)
        }
        
        return task
    }
    
    func decode<T: Decodable>(from data: Data?, to type: T.Type) -> T? {
        // 1. 데이터가 비었을 때
        guard let data = data else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(type, from: data)
            return data
        } catch {
            // 2. decoding에서 에러 발생했을 때
            print("failed decoding: \(error)")
            return nil
        }
    }
}
