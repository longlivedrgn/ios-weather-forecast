//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

final class WeatherNetworkDispatcher {
    
    private let networkSession: NetworkSession
    private let deserializer = JSONNetworkDeserializer(decoder: JSONDecoder())
    
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func makeWeatherRequest(of weatherAPI: WeatherAPI, in coordinate: Coordinate) -> URLRequest {
        let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    func makeImageRequest(_ icon: String) -> URLRequest {
        let url = WeatherAPI.makeImageURL(icon: icon)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    func requestWeatherInformation(of weatherAPI: WeatherAPI,
                                   in coordinate: Coordinate) async throws -> Decodable? {
        
        let urlRequest = makeWeatherRequest(of: weatherAPI, in: coordinate)
        let result = try await networkSession.fetchData(from: urlRequest)
        switch result {
        case .success(let data):
            let decodeData = try self.deserializer.deserialize(data: data, to: weatherAPI.decodingType)
            return decodeData
        case .failure(let error):
            print(error.errorDescription)
            return nil
        }
    }
    
    func requestWeatherImage(icon: String) async throws -> UIImage? {
        
        let urlRequest = makeImageRequest(icon)
        
        let result = try await networkSession.fetchData(from: urlRequest)
        
        switch result {
            
        case .success(let data):
            guard let image = UIImage(data: data) else { throw NetworkError.emptyData }
            return image
        
        case .failure(let error):
            print(error.errorDescription)
            return nil
        }
    }
}

