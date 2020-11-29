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
            .font(Font.body.bold())
            .padding([.leading, .trailing], 16)
            .background(LinearGradient(Color.primaryBlue.opacity(0.60), Color.primaryBlue, startPoint: .top, endPoint: .bottom))
            .cornerRadius(50)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(height: 44)
            .foregroundColor(Color.white)
            .font(Font.body.bold())
            .padding([.leading, .trailing], 16)
            .background(LinearGradient(Color.secondary.opacity(0.60), Color.secondary, startPoint: .top, endPoint: .bottom))
            .cornerRadius(50)
    }
}
