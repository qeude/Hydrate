//
//  WaterWave.swift
//  Hydrate
//
//  Created by Quentin Eude on 06/10/2020.
//

import SwiftUI

struct CircleWaveView<Content: View>: View {
    @State private var waveOffset = Angle(degrees: 0)
    var percent: CGFloat
    let user: DbUser
    let content: Content

    init(percent: CGFloat, user: DbUser, @ViewBuilder content: @escaping () -> Content) {
        self.percent = percent
        self.user = user
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .foregroundColor(Color.lighterBackground)
                    .overlay(
                        Circle()
                            .stroke(Color.darkShadow.opacity(0.15), lineWidth: 5)
                            .blur(radius: 3)
                            .offset(x: 2, y: 2)
                            .mask(Circle().fill(LinearGradient(Color.darkShadow, Color.clear)))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.lightShadow, lineWidth: 5)
                            .blur(radius: 3)
                            .offset(x: -2, y: -2)
                            .mask(Circle().fill(LinearGradient(Color.clear, Color.darkShadow
                            )))
                    )

                Circle()
                    .stroke(Color.clear)
                    .overlay(
                        Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(percent)/100)
                            .fill(Color.primaryBlue.opacity(1))
                            .clipShape(Circle())
                            .animation(self.waveOffset == Angle(degrees: 0)
                                        ? .default
                                        : Animation
                                        .linear(duration: 1)
                                        .repeatForever(autoreverses: false), value: waveOffset)
                            .animation(.easeOut(duration: 1), value: percent)
                    )
                self.content

            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.waveOffset = Angle(degrees: 360)
        }
        .onChange(of: percent, perform: { _ in
            print("changed value")
            self.waveOffset = Angle(degrees: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.waveOffset = Angle(degrees: 360)
            }
        })
    }
}

extension CircleWaveView where Content == EmptyView {
    init(percent: CGFloat, user: DbUser) {
        self.init(percent: percent, user: user, content: { EmptyView() })
    }
}

struct Wave: Shape {

    var offset: Angle
    var percent: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(offset.degrees, percent) }
        set {
            offset = Angle(degrees: newValue.first)
            percent = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()

        // empirically determined values for wave to be seen
        // at 0 and 100 percent
        let lowfudge = 0.02
        let highfudge = 0.98

        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.015 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)

        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))

        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }

        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()

        return p
    }
}

struct WaterWaveView_Previews: PreviewProvider {
    static var previews: some View {
        CircleWaveView(percent: CGFloat(51),
                       user: DbUser(id: "test", time: nil, firstname: "Quentin", email: "test@test.fr", dailyGoal: 2000))                        .frame(width: 200, height: 200, alignment: .center)

    }
}
