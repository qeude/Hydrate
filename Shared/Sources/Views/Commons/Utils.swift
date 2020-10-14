//
//  Utils.swift
//  Hydrate
//
//  Created by Quentin Eude on 13/10/2020.
//
import SwiftUI
import Foundation

func changeValueOverTime(value: Binding<CGFloat>, newValue: CGFloat, duration: Double) {
    let timeIncrements = 0.02
    let steps = Int(duration / timeIncrements)
    var count = 0
    let increment = (newValue -  value.wrappedValue) / CGFloat(steps)
    Timer.scheduledTimer(withTimeInterval: timeIncrements, repeats: true) { timer in
        value.wrappedValue += increment
        count += 1
        if count == steps {
            timer.invalidate()
        }
    }
}
