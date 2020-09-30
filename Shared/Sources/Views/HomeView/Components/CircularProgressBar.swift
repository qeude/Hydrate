//
//  CircularProgressBar.swift
//  Hydrate
//
//  Created by Quentin Eude on 28/09/2020.
//

import SwiftUI

struct CircularProgressBar: View {
    @Binding var progress: Float
    var centerCircleCoefficient: CGFloat = 0.80
    var deltaCenterCircleCoefficient: CGFloat {
        return ((1 - self.centerCircleCoefficient) / 2) + centerCircleCoefficient
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(Color.lighterBackground)
                    .overlay(
                        Circle()
                            .stroke(Color.darkShadow, lineWidth: 7)
                            .blur(radius: 10)
                            .offset(x: 2, y: 2)
                            .mask(Circle().fill(LinearGradient(Color.darkShadow, Color.clear)))
                    )
                    .overlay(
                           Circle()
                               .stroke(Color.lightShadow, lineWidth: 12)
                               .blur(radius: 5)
                               .offset(x: -2, y: -2)
                               .mask(Circle().fill(LinearGradient(Color.clear, Color.darkShadow
                               )))
                       )
                Circle()
                    .frame(width: geo.size.width * centerCircleCoefficient,
                           height: geo.size.height * centerCircleCoefficient)
                    .foregroundColor(Color.background)
                    .shadow(color: Color.darkShadow.opacity(0.3), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.lightShadow.opacity(0.7), radius: 10, x: -5, y: -5)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: geo.size.width - geo.size.width * deltaCenterCircleCoefficient,
                                               lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 270.0))
                    .foregroundColor(Color.blue)
                    .frame(width: geo.size.width * deltaCenterCircleCoefficient,
                           height: geo.size.height * deltaCenterCircleCoefficient)

            }
            .padding(.trailing, 20)
            .animation(.linear)
        }
    }
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: .constant(50))
    }
}
