//
//  JSONNetworkDeserializer.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/03.
//

import UIKit

struct JSONNetworkDeserializer {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func deserialize(data: Data, to type: Decodable.Type) throws -> Decodable {
        let data = try decoder.decode(type, from: data)
        return data
    }
}

