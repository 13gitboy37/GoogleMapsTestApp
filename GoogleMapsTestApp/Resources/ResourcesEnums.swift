//
//  ResourcesEnums.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 14.11.2023.
//

import Foundation

enum ImageEnum {
    case calendar
    case speedometr
    case distance
    case marker

    var name: String {
        switch self {
        case .calendar:
            return "calendar"
        case .speedometr:
            return "speedometr"
        case .distance:
            return "distance"
        case .marker:
            return "marker"
        }
    }
}
