//
//  CoordinateModel.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 18.11.2023.
//

import Foundation

enum CoordinateModel: Decodable {
    case coordinate(Double)
    case date(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(Double.self) {
            self = .coordinate(data)
            return
        }
        if let data = try? container.decode(String.self) {
            self = .date(data)
            return
        }
        throw DecodingError.typeMismatch(
            CoordinateModel.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Wrong type for CoordinateModel"
            )
        )
    }
}
