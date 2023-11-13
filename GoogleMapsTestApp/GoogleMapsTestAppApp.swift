//
//  GoogleMapsTestAppApp.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 13.11.2023.
//

import GoogleMaps
import SwiftUI

@main
struct GoogleMapsTestAppApp: App {
    init () {
        GMSServices.provideAPIKey("AIzaSyBCzZZicSBHz6H9p-6-U3Jdz8OATYFhFk4")
    }
    var body: some Scene {
        WindowGroup {
            MapView()
        }
    }
}
