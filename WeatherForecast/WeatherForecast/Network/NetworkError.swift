//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

enum NetworkError: Error {
    case outOfReponseCode
    case failedRequest
    case dataIsEmpty
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .outOfReponseCode:
            return "응답코드가 정상코드 범위에 없습니다."
        case .failedRequest:
            return "잘못된 요청입니다."
        case .dataIsEmpty:
            return "데이터가 올바르지 않습니다."
        }
    }
}
