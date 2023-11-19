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

    @Binding var coordinates: [CoordinateForMapModel]
    @Binding var zoom: Float

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        context.coordinator.zoom = zoom
        context.coordinator.coordinates = coordinates
        context.coordinator.changeZoom(mapView: uiView)
        context.coordinator.addMarker(mapView: uiView)
        context.coordinator.addPolygon(mapView: uiView)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(coordinates: coordinates, zoom: zoom)
    }
}

final class Coordinator: NSObject {
    var coordinates: [CoordinateForMapModel]
    var zoom: Float

    init(coordinates: [CoordinateForMapModel], zoom: Float) {
        self.coordinates = coordinates
        self.zoom = zoom
    }

    func changeZoom(mapView: GMSMapView) {
        mapView.animate(toZoom: zoom)
    }

    func addMarker(mapView: GMSMapView) {
        guard let coordinate = coordinates.first else {
            return
        }
        let marker = GMSMarker()
        marker.icon = UIImage(named: ImageEnum.marker.name)
        marker.setIconSize(scaledToSize: CGSize(width: 20, height: 20))
        marker.position = CLLocationCoordinate2D(latitude: coordinate.lantitude, longitude: coordinate.longitude)
        marker.map = mapView
    }

    func addPolygon(mapView: GMSMapView) {
        guard !coordinates.isEmpty else {
            return
        }
        let path = GMSMutablePath()
        coordinates.forEach { path.add(CLLocationCoordinate2D(latitude: $0.lantitude, longitude: $0.longitude)) }

        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.map = mapView
    }
}

extension Coordinator: GMSMapViewDelegate {
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        guard let coordinate = coordinates.first else {
            return
        }
        mapView.moveCamera(
            GMSCameraUpdate.setCamera(
                GMSCameraPosition(
                    latitude: coordinate.lantitude,
                    longitude: coordinate.longitude,
                    zoom: zoom
                )
            )
        )
    }
}
