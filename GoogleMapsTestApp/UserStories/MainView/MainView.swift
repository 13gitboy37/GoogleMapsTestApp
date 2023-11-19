//
//  MainView.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 13.11.2023.
//

import GoogleMaps
import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isAnimateRoute: Bool = false

    var body: some View {
        ZStack {
            GoogleMapView(
                coordinates: $viewModel.coordinates,
                zoom: $viewModel.zoom,
                isAnimateRoute: $isAnimateRoute
            )
                .ignoresSafeArea(edges: .top)
            VStack {
                createLeftSideButtonBar()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)

                createBottomSheet()
            }
        }
        .disabled(viewModel.isLoading)
        .overlay(
            ProgressView()
                .background(Color.white)
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(viewModel.isLoading ? 1 : 0)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.fetchCoordinates()
        }
    }

    private func createLeftSideButtonBar() -> some View {
        VStack {
            createMapButton(image: Image(systemName: "plus")) {
                viewModel.didTapPlusButton()
            }

            createMapButton(image: Image(systemName: "minus")) {
                viewModel.didTapMinusButton()
            }

            createMapButton(image: Image(systemName: "eye")) {
                print("tap eye")
            }
            .padding(.top, 119)
        }
    }

    private func createMapButton(image: Image,
                                 action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Rectangle()
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(width: 44, height: 45)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
                .overlay(
                    image
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.gray)
                )
                .background(Color.white)
                .cornerRadius(10)
        }
    }

    private func createBottomSheet() -> some View {
        VStack(alignment: .leading) {
            Text("Бензовоз")
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 16)
                .padding(.leading, 16)
                .padding(.bottom, 8.5)

            HStack(spacing: 20) {
                createInfoButton(
                    image: Image(ImageEnum.calendar.name),
                    text: viewModel.makeDatesString(),
                    action: { print("calendar tapped") }
                )

                createInfoButton(
                    image: Image(ImageEnum.distance.name),
                    text: "10 км",
                    action: { print("distance tapped") }
                )

                createInfoButton(
                    image: Image(ImageEnum.speedometr.name),
                    text: "До 98 км/ч",
                    action: { print("speed tapped") }
                )
            }
            .padding(.top, 4)
            .padding(.leading, 13)
            .padding(.bottom, 10)

            ProgressView(value: viewModel.data, label: {}, currentValueLabel: { Text("30%") })
                .progressViewStyle(BarProgressStyle(height: 3))
                .padding(.top, 43.5)
                .padding(.horizontal, 16)
                .padding(.bottom, 26)

            createControlReplayButton()
            .frame(maxWidth: .infinity)
            .padding(.bottom, 23)
        }
        .frame(height: 213)
        .background(Color.white.opacity(0.98))
    }

    private func createInfoButton(image: Image, text: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 19, height: 19)
                Text(text)
                    .font(.system(size: 12))
                    .padding(.leading, -4)
            }
            .frame(alignment: .center)
            .foregroundColor(.black)
        }
        .disabled(true)
    }

    private func createControlReplayButton() -> some View {
        HStack {
            Button {
                print("change speed")
            } label: {
                Text("1x")
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(width: 44, height: 44)
            .padding(.leading, 16)

            Spacer()

            Button {
                isAnimateRoute.toggle()
            } label: {
                Image(systemName: isAnimateRoute ? "pause.fill" : "play.fill")
                    .font(.system(size: 34))
            }

            Spacer()

            Button {
                print("tapped info")
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 18, weight: .semibold))
            }
            .frame(width: 44, height: 44)
            .padding(.trailing, 16)
        }
    }
}
