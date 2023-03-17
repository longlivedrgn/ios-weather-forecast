//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

final class NetworkManager {
    private let session: URLSession
    private let networkModel = NetworkModel()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) {
        let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
        let urlRequest = URLRequest(url: url)
        
        let task = networkModel.task(session: session, urlRequest: urlRequest) { result in
            
            switch result {
            case .success(let data):
                let result = self.networkModel.decode(from: data, to: weatherAPI.decodingType)
                print("결과 나옴: \(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
