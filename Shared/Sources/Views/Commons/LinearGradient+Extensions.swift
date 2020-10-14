//
//  LinearGradient+Extensions.swift
//  Hydrate
//
//  Created by Quentin Eude on 13/10/2020.
//

import Foundation
import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
