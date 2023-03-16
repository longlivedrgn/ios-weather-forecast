//
//  URLResponse+.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

extension URLResponse {
    
    private var successRange: ClosedRange<Int> {
        return 200...299
    }
    
    var checkResponse: Bool {
        guard let httpResponse = self as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
             return false
        }
        return true
    }
}
