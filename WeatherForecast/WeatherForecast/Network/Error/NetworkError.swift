//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

enum NetworkError: LocalizedError {
    
    case outOfReponseCode
    case failedRequest
    case failedDecoding
    case failedtypeCasting
    case inappropriateData

    var errorDescription: String? {
        
        switch self {
        case .outOfReponseCode:
            return "응답코드가 정상코드 밖에 있습니다."
        case .failedRequest:
            return "잘못된 요청입니다."
        case .failedDecoding:
            return "디코딩에 실패하였습니다."
        case .failedtypeCasting:
            return "타입 캐스팅에 실패하였습니다."
        case .inappropriateData:
            return "알맞은 데이터가 아닙니다."
        }
    }
}
