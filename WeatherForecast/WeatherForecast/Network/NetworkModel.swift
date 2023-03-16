//
//  NetworkModel.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/17.
//

import UIKit

final class NetworkModel {
    
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
