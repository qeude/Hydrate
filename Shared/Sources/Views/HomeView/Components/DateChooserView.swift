//
//  DateChooserView.swift
//  Hydrate
//
//  Created by Quentin Eude on 24/10/2020.
//

import SwiftUI

struct DateChooserView: View {
    var label: String
    var leftAction: () -> Void
    var rightAction: () -> Void
    var leftButtonDisable: Bool = false
    var rightButtonDisable: Bool = false

    var body: some View {
        HStack {
            Button(action: leftAction, label: {
                Image(systemName: "chevron.left")
            }).disabled(leftButtonDisable)
            Text(label).bold()
            Button(action: rightAction, label: {
                Image(systemName: "chevron.right")
            }).disabled(rightButtonDisable)

        }
    }
}

struct DateChooserView_Previews: PreviewProvider {
    static var previews: some View {
        DateChooserView(label: "Date") {
            print("left")
        } rightAction: {
            print("right")
        }

    }
}
