//
//  DrinkEntryCell.swift
//  Hydrate
//
//  Created by Quentin Eude on 29/11/2020.
//

import SwiftUI
import Firebase

struct DrinkEntryCell: View {
    let drinkEntry: DrinkEntry

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(drinkEntry.time!.dateValue(), formatter: Self.dateFormatter)")
                .foregroundColor(.secondaryText)
                .font(.system(size: 12))
            Text("\(String(format: "%.0f", drinkEntry.quantity)) ml")
                .foregroundColor(.primaryText)
                .bold()
        }.frame(height: 44)
    }
}

struct DrinkEntryCell_Previews: PreviewProvider {
    static var previews: some View {
        DrinkEntryCell(drinkEntry: DrinkEntry(id: "toto", time: Timestamp(date: Date()), quantity: 200))
    }
}
