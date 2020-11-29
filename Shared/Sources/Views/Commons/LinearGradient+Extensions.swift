//
//  LinearGradient+Extensions.swift
//  Hydrate
//
//  Created by Quentin Eude on 13/10/2020.
//

import Foundation
import SwiftUI

extension LinearGradient {
    init(_ colors: Color..., startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}
