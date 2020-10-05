//
//  Barchart.swift
//  Hydrate
//
//  Created by Quentin Eude on 04/10/2020.
//

import SwiftUI

struct Barchart: View {
    var data: [(String, Double)] = [
        (Date(timeIntervalSince1970: 1601300643).weekdayName(.veryShort), 3000), //28 sept
        (Date(timeIntervalSince1970: 1601387043).weekdayName(.veryShort), 2000), //29 sept
        (Date(timeIntervalSince1970: 1601473443).weekdayName(.veryShort), 500), //30 sept
        (Date(timeIntervalSince1970: 1601559843).weekdayName(.veryShort), 1750), //1 oct
        (Date(timeIntervalSince1970: 1601646243).weekdayName(.veryShort), 2000), //2 oct
        (Date(timeIntervalSince1970: 1601732643).weekdayName(.veryShort), 1000), //3 oct
        (Date(timeIntervalSince1970: 1601819043).weekdayName(.veryShort), 1250) //4 oct
    ]

    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 24) {
                    ForEach(Array(data.enumerated()), id: \.0) { index, item in
                        BarView(maxValue: data.max { $0.1 < $1.1 }?.1 ?? 0, value: item.1, day: item.0)
                            .scaleEffect(
                                self.touchLocation > CGFloat(index)/CGFloat(self.data.count)
                                    && self.touchLocation < CGFloat(index+1)/CGFloat(self.data.count) ?
                                    CGSize(width: 1.1, height: 1.1) :
                                    CGSize(width: 1, height: 1), anchor: .bottom
                            )
                    }
                }
                .highPriorityGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.touchLocation = value.location.x / geo.size.width
                            self.showValue = true
                            self.currentValue = self.getCurrentValue(width: geo.size.width) ?? 0
                            self.showLabelValue = true
                        })
                        .onEnded({ _ in
                            self.showValue = false
                            self.touchLocation = -1
                            self.showLabelValue = false
                        })
                )
                if self.showLabelValue && self.getCurrentValue(width: geo.size.width) != nil {
                    LabelView(arrowOffset: self.getArrowOffset(width: geo.size.width),
                              title: .constant("\(self.getCurrentValue(width: geo.size.width) ?? 0)"))
                        .offset(x: self.getLabelViewOffset(width: geo.size.width), y: -6)
                        .foregroundColor(.primaryText)
                }

            }
            .animation(.default)
        }
    }

    func getCurrentValue(width: CGFloat) -> Double? {
        guard !self.data.isEmpty else { return nil}
        let index = max(0, min(self.data.count-1, Int(floor((self.touchLocation*width)/(width/CGFloat(self.data.count))))))
        return self.data[index].1
    }

    func getArrowOffset(width: CGFloat) -> Binding<CGFloat> {
        let realLoc = self.touchLocation * width - 50
        if realLoc < 10 {
            return .constant(realLoc - 10)
        } else if realLoc > width - 100 {
            return .constant(((width - 100) - realLoc) * -1)
        } else {
            return .constant(0)
        }
    }

    func getLabelViewOffset(width: CGFloat) -> CGFloat {
        return min(width - 100, max(-5, self.touchLocation * width - 50))
    }
}

struct BarView: View {
    var maxValue: Double
    var value: Double
    var day: String

    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottom) {
                    Capsule()
                        .frame(width: 20, height: CGFloat(geo.size.height))
                        .foregroundColor(.lighterBackground)
                        .overlay(
                            Capsule()
                                .stroke(Color.darkShadow.opacity(0.15), lineWidth: 5)
                                .blur(radius: 2)
                                .offset(x: 2, y: 2)
                                .mask(Capsule().fill(LinearGradient(Color.mediumShadow, Color.clear)))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.lightShadow, lineWidth: 5)
                                .blur(radius: 2)
                                .offset(x: -2, y: -2)
                                .mask(Capsule().fill(LinearGradient(Color.clear, Color.mediumShadow)))
                        )
                        .overlay(
                            Capsule().stroke(Color.lightShadow, lineWidth: 1)
                        )

                    Capsule()
                        .frame(width: 20, height: CGFloat(CGFloat(Float(value) / Float(maxValue)) * geo.size.height))
                        .foregroundColor(.primary)
                }
                Text(day)
            }
        }
    }
}

struct LabelView: View {
    @Binding var arrowOffset: CGFloat
    @Binding var title: String
    var body: some View {
        VStack {
            ArrowUp()
                .fill(Color.white)
                .frame(width: 20, height: 12, alignment: .center)
                .shadow(color: Color.gray, radius: 8, x: 0, y: 0)
                .offset(x: getArrowOffset(offset: self.arrowOffset), y: 12)
            ZStack {
                RoundedRectangle(cornerRadius: 8).frame(width: 100, height: 32, alignment: .center)
                    .foregroundColor(Color.white).shadow(radius: 8)
                Text(self.title).font(.caption).bold()
                ArrowUp()
                    .fill(Color.white)
                    .frame(width: 20, height: 12, alignment: .center)
                    .zIndex(999)
                    .offset(x: getArrowOffset(offset: self.arrowOffset), y: -20)
            }
        }
    }

    func getArrowOffset(offset: CGFloat) -> CGFloat {
        return max(-36, min(36, offset))
    }
}

struct ArrowUp: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width/2, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
}

struct Barchart_Previews: PreviewProvider {
    static var previews: some View {
        Barchart()
    }
}
