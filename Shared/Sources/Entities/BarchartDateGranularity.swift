//
//  DateGranylarity.swift
//  Hydrate (iOS)
//
//  Created by Quentin Eude on 28/10/2020.
//

import Foundation

enum BarchartDateGranularity: CaseIterable {
    case daily, monthly, annualy

    var localized: String {
        switch self {
        case .daily:
            return L10n.BarchartDateGranularity.Daily.text
        case .monthly:
            return L10n.BarchartDateGranularity.Monthly.text
        case .annualy:
            return L10n.BarchartDateGranularity.Annualy.text
        }
    }
}
