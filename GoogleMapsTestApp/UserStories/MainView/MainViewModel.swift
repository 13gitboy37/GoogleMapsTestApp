//
//  MainViewModel.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 18.11.2023.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    @Published var dates: [String] = []
    @Published var coordinates: [CoordinateForMapModel] = []
    @Published var zoom: Float = 10
    @Published var isLoading = false
    @Published var data = 0.0

    private let networkService: NetworkService
    private let dateFormatter = DateFormatter()
    private let receiveQueue = DispatchQueue.global(qos: .userInteractive)

    private var cancellables: Set<AnyCancellable> = .init()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchCoordinates() {
        isLoading = true
        networkService.getCoordinatesPublisher(.getCoordinates)
            .compactMap { $0 }
            .receive(on: receiveQueue)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error)
                }
                self?.isLoading = false
            } receiveValue: { [weak self] coordinates in
                var datesForMap = [String]()
                var coordinatesForMap = [CoordinateForMapModel]()
                coordinates.forEach { coordinateModel in
                    var coordinate = CoordinateForMapModel(longitude: 0, lantitude: 0)
                    if case .date(let date) = coordinateModel[0] {
                        datesForMap.append(date)
                    }

                    if case .coordinate(let longitude) = coordinateModel[1] {
                        coordinate.longitude = longitude
                    }

                    if case .coordinate(let lantitude) = coordinateModel[2] {
                        coordinate.lantitude = lantitude
                    }
                    coordinatesForMap.append(coordinate)
                }
                DispatchQueue.main.async {
                    self?.dates = datesForMap
                    self?.coordinates = coordinatesForMap
                }
            }
            .store(in: &cancellables)
    }

    func makeDatesString() -> String {
        let firstDate = dates.first
        let lastDate = dates.last
        return "\(makeDate(date: firstDate ?? "")) - \(makeDate(date: lastDate ?? ""))"
    }

    func makeDate(date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date ?? Date())
        return dateString
    }

    func didTapMinusButton() {
        if zoom < 0 {
            zoom = 1
        } else {
            zoom -= 1
        }
    }

    func didTapPlusButton() {
        if zoom < 20 {
            zoom += 1
        } else {
            zoom = 20
        }
    }
}
