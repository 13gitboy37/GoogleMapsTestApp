//
//  NetworkService.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 18.11.2023.
//

import Combine
import Foundation

protocol NetworkService {
    func getCoordinatesPublisher(_ endpoint: Endpoint) -> AnyPublisher<[[CoordinateModel]], APIError>
}

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
