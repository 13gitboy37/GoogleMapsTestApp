//
//  NetworkService.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 18.11.2023.
//

import Combine
import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}

enum HttpMethod: String {
    case get = "GET"
}

enum Endpoint {
    case getCoordinates

    var path: String {
        switch self {
        case .getCoordinates:
            return "/coordinates.json"
        }
    }

    var httpMethod: HttpMethod {
        switch self {
        case .getCoordinates:
            return .get
        }
    }
}

enum APIEnvironment {
    case dev

    var baseURL: String {
        switch self {
        case .dev:
            return "https://dev5.skif.pro"
        }
    }
}

protocol NetworkService {
    func getCoordinatesPublisher(_ endpoint: Endpoint) -> AnyPublisher<[[CoordinateModel]], APIError>
}

final class NetworkManager: NetworkService {
    private let baseURL: String
    private let subscribeQueue = DispatchQueue.global()

    init(environment: APIEnvironment = NetworkManager.defaultEnvironment()) {
        self.baseURL = environment.baseURL
    }

    static func defaultEnvironment() -> APIEnvironment {
        return .dev
    }

    func getCoordinatesPublisher(_ endpoint: Endpoint) -> AnyPublisher<[[CoordinateModel]], APIError> {
        guard let url = URL(string: baseURL + endpoint.path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: subscribeQueue)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw APIError.requestFailed("Request failed with status code: \(statusCode)")
                }
            }
            .decode(type: [[CoordinateModel]].self, decoder: JSONDecoder())
            .tryMap { $0 }
            .mapError { error -> APIError in
                if error is DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
}
