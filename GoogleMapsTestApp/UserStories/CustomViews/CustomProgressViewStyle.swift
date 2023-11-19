//
//  CustomProgressViewStyle.swift
//  GoogleMapsTestApp
//
//  Created by Никита Мошенцев on 14.11.2023.
//

import SwiftUI

struct BarProgressStyle: ProgressViewStyle {

    var color: Color = .blue
    var height: Double = 3
    var labelFontStyle: Font = .body

    func makeBody(configuration: Configuration) -> some View {

        let progress = configuration.fractionCompleted ?? 0.0

        GeometryReader { geometry in
            HStack(spacing: 0) {
                Circle()
                    .fill(progress > 0.01 ? .blue : .gray)
                    .frame(width: 6, height: 6)
                    .offset(x: 5)

                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color.gray)
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(
                        ZStack {
                            HStack(alignment: .center, spacing: 0) {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(color)
                                    .frame(width: geometry.size.width * progress, height: height)
//                                VStack {
//                                    Text("70 км/ч")
//                                        .font(.system(size: 11))
//                                        .foregroundColor(.gray)
//                                        .padding(.bottom, 8)
                                    
                                    Circle()
                                        .fill(color)
                                        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 20, height: 20)
                                        )
//                                }
                            }
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    )

                Circle()
                    .fill(progress > 0.99 ? .blue : .gray)
                    .frame(width: 6, height: 6)
                    .offset(x: -5)
            }
        }
    }
}


/*
 Text("70 км/ч")
     .font(.system(size: 11))
     .foregroundColor(.gray)
     .padding(.bottom, 8)
 */


//struct BarProgressStyle: ProgressViewStyle {
////    var color: Color = .purple
//    var height: Double = 20.0
//    var labelFontStyle: Font = .body
//
//    func makeBody(configuration: Configuration) -> some View {
//
////        let progress = configuration.fractionCompleted ?? 0.0
//
////        GeometryReader { geometry in
//
////            VStack(alignment: .leading) {
////                configuration.
//
////                configuration.label
////                    .font(labelFontStyle)
////
////                RoundedRectangle(cornerRadius: 10.0)
//////                    .fill(Color(uiColor: .systemGray5))
////                    .frame(height: height)
////                    .frame(width: geometry.size.width)
////                    .overlay() {
////                        RoundedRectangle(cornerRadius: 10.0)
//////                            .fill(color)
////                            .frame(width: geometry.size.width * progress)
////                            .overlay (
////                                if let currentValueLabel = configuration.currentValueLabel {
////
////                                    currentValueLabel
////                                        .font(.headline)
////                                        .foregroundColor(.white)
////                                }
////                            )
////                    }
//
////            }

//        }
//    }
//}

//
//VStack(alignment: .leading) {
//    Circle()
//        .fill(color)
//        .frame(width: 10, height: 10)
//        .border(.white)
//        .overlay(
//            Circle()
//                .stroke(Color.white)
//                .frame(width: 10, height: 10)
//        )
////                                .frame(width: geometry.size.width * progress)
//}
