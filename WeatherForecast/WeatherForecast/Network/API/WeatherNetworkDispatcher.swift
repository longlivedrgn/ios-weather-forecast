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
    
    func requestWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) async throws -> Decodable {
        
        let urlRequest = makeWeatherRequest(of: weatherAPI, in: coordinate)
        let networkResult = try await networkSession.task(urlRequest: urlRequest)
        
        switch networkResult {
        case .success(let data):
            do {
                let decodedData = try self.deserializer.deserialize(data: data, to: weatherAPI.decodingType)
                return decodedData
            } catch {
                // MARK: - Error : Network를 통해 데이터는 불러왔지만, decoding 실패 (NetworkError.failedDecoding)
                throw error
            }
        case .failure(let error):
            // MARK: - Error: Network를 통해 데이터 불러오기 실패
            throw error
        }
    }
    
    func requestWeatherImage(icon: String) async throws -> UIImage? {
        
        let urlRequest = makeImageRequest(icon)
        let networkResult = try await networkSession.task(urlRequest: urlRequest)
        
        switch networkResult {
        case .success(let data):
            return UIImage(data: data)
        case .failure(let error):
            throw error
        }
    }
}

