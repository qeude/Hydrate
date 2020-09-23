//
//  ButtonStyles`.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(height: 44)
            .foregroundColor(Color.white)
            .background(Color.primary)
            .cornerRadius(18)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(height: 44)
            .foregroundColor(Color.white)
            .background(Color.gray)
            .cornerRadius(18)
    }
}
