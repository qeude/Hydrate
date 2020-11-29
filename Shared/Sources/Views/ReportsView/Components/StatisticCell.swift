//
//  StatisticCell.swift
//  Hydrate (iOS)
//
//  Created by Quentin Eude on 27/10/2020.
//

import SwiftUI

struct StatisticCell: View {
    var title: String
    var value: String

    var body: some View {
        ZStack {
            Color.lightBackground.cornerRadius(20)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.secondaryText)
                    .font(.system(size: 12))
                Text(value)
                    .foregroundColor(.primaryText)
                    .bold()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct StatisticCell_Previews: PreviewProvider {
    static var previews: some View {
        StatisticCell(title: "Average intake", value: "1900ml").frame(width: 150, height: 70, alignment: .center)
    }
}
