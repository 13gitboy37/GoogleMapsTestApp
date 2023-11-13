//
//  ContentView.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 13.11.2023.
//

import GoogleMaps
import SwiftUI

struct MapView: View {
    private var title: String = "Бензовоз"
    private var speedTitle: String = "1x"
    var body: some View {
        VStack {
            ZStack {
                GoogleMapView()
                VStack {
                    Button {
                        print("tap plus")
                    } label: {
                        Rectangle()
                            .stroke(Color(red: 0.75, green: 0.77, blue: 0.85), lineWidth: 0.5)
                            .frame(width: 44, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.gray)
                            )
                            .background(Color.white)
                            .cornerRadius(10)
                    }

                    Button {
                        print("tap minus")
                    } label: {
                        Rectangle()
                            .stroke(Color(red: 0.75, green: 0.77, blue: 0.85), lineWidth: 0.5)
                            .frame(width: 44, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "minus")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.gray)
                            )
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                HStack {
                    Button {
                        print("calendar tapped")
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .padding(.top, 4)
                                .padding(.leading, 13)
                        }
                    }
                }
                HStack {
                    Button {
                        print("change speed")
                    } label: {
                        Text(speedTitle)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(width: 44, height: 44)
                    .padding(.leading, 16)

                    Spacer()

                    Button {
                        print("tapped play")
                    } label: {
                        Image(systemName: "play.fill")
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
                .frame(maxWidth: .infinity)
                .padding(.bottom, 23)
            }
            .frame(height: 213)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MapView()
}
