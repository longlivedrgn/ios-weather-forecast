//
//  NetworkModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/17.
//

import UIKit

typealias NetworkResult = Result<Data, NetworkError>

final class NetworkSession {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from urlRequest: URLRequest) async throws -> NetworkResult {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard response.checkResponse else {
                return .failure(.outOfReponseCode)
            }
            return .success(data)
        } catch is URLError {
            return .failure(.failedRequest)
        } catch is DecodingError {
            return .failure(.emptyData)
        }
    }
}
