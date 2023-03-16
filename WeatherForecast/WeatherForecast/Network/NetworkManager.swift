//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) {
        let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
        let urlRequest = URLRequest(url: url)
        
        let task = task(session: session, urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                self.convertData(from: data, to: weatherAPI.decodingType)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func task(session: URLSession, urlRequest: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.failedRequest))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.outOfReponseCode))
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataIsEmpty))
                return
            }
            
            completionHandler(.success(data))
        }
        return task
    }
    
    func convertData<T: Decodable>(from data: Data?, to type: T.Type) {
        guard let result = decode(from: data, to: type) else { return }
        print("결과야 \(result)")
    }
    
    func decode<T: Decodable>(from data: Data?, to type: T.Type) -> T? {
        guard let data = data else { return nil }
        
        let decoder = JSONDecoder()
        print("여기까진 ok")
        do {
            let data = try decoder.decode(type, from: data)
            return data
        } catch {
            return nil
        }
    }
    
}
