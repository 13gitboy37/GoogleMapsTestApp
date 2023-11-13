//
//  GoogleMapView.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 13.11.2023.
//

import GoogleMaps
import SwiftUI

struct GoogleMapView: UIViewRepresentable {
    typealias UIViewType = GMSMapView

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: -23.5899619, longitude: -46.66747, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
}
