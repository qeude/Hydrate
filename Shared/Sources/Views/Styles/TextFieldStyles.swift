//
//  TextFieldStyles.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 28)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(Color.gray, lineWidth: 0.5)
            )
            .foregroundColor(Color.primaryText)
    }
}
