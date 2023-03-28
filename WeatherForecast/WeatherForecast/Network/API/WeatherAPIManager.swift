//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

final class WeatherAPIManager {
    
    private let networkModel: NetworkModel
    
    init(networkModel: NetworkModel) {
        self.networkModel = networkModel
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
    
    func fetchWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) -> Decodable? {
        
        let urlRequest = makeWeatherRequest(of: weatherAPI, in: coordinate)
        let group = DispatchGroup()
        var weatherInformation: Decodable?
        
         group.enter()
        let task = networkModel.task(urlRequest: urlRequest) { result in
            
            switch result {
            case .success(let data):
                do {
                    let decodedData = try self.networkModel.decode(from: data, to: weatherAPI.decodingType)
                    weatherInformation = decodedData
                } catch {
                    print(error.localizedDescription)
                    weatherInformation = nil
                }
            case .failure(let error):
                print(error.localizedDescription)
                weatherInformation = nil
            }
            group.leave()
        }

        task.resume()
        group.wait()

        return weatherInformation
    }
    
    func fetchWeatherImage(icon: String) -> UIImage? {
        
        let urlRequest = makeImageRequest(icon)
        let group = DispatchGroup()
        var weatherImage: UIImage?
        
        group.enter()
        let task = networkModel.task(urlRequest: urlRequest) { result in
            
            switch result {
            case .success(let data):
                weatherImage = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
                weatherImage = nil
            }
            group.leave()
        }
        
        task.resume()
        group.wait()
        
        return weatherImage
    }
}
 
