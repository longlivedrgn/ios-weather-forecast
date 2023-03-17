//
//  NetworkModel.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/17.
//

import UIKit

typealias NetworkResult = Result<Data, NetworkError>

final class NetworkModel {
    
    func task(session: URLSession, urlRequest: URLRequest, completionHandler: @escaping (NetworkResult) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.failedRequest))
                return
            }
            
            guard response?.checkResponse == true else {
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
    
    func decode<T: Decodable>(from data: Data, to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let data = try decoder.decode(type, from: data)
            return data
        } catch {
            return nil
        }
    }
    
}
