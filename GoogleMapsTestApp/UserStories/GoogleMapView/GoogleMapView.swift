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
    @Binding var isAnimateRoute: Bool

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
        if isAnimateRoute {
            context.coordinator.playAnimate(mapView: uiView)
        } else {
            context.coordinator.stopAnimate(mapView: uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(coordinates: coordinates, zoom: zoom, parent: self)
    }
}

final class Coordinator: NSObject {
    var coordinates: [CoordinateForMapModel]
    var zoom: Float
    var parent: GoogleMapView

    var currentPosition: Int = 0
    let marker = GMSMarker()
    var timer = Timer()

    init(coordinates: [CoordinateForMapModel], zoom: Float, parent: GoogleMapView) {
        self.coordinates = coordinates
        self.zoom = zoom
        self.parent = parent
    }

    func changeZoom(mapView: GMSMapView) {
        mapView.animate(toZoom: zoom)
    }

    func addMarker(mapView: GMSMapView) {
        guard let coordinate = coordinates.first else {
            return
        }

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
        polyline.strokeWidth = 3.0
        polyline.map = mapView
    }

    func playAnimate(mapView: GMSMapView) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: true, block: { [weak self] _ in
            self?.animateTrack(mapView: mapView)
        })

        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }

    func stopAnimate(mapView: GMSMapView) {
        currentPosition = 0
        timer.invalidate()
        addMarker(mapView: mapView)
        parent.isAnimateRoute = false
    }

    func animateTrack(mapView: GMSMapView){
        if currentPosition <= self.coordinates.count - 1 {
            let position = CLLocationCoordinate2D(
                latitude: self.coordinates[currentPosition].lantitude,
                longitude: self.coordinates[currentPosition].longitude
            )
            self.marker.position = position
            mapView.camera = GMSCameraPosition(target: position, zoom: zoom)
            self.marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))

            if currentPosition == self.coordinates.count - 1 {
                stopAnimate(mapView: mapView)
            }

            currentPosition += 1
        }
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
