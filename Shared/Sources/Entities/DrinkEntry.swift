//
//  DrinkEntry.swift
//  Hydrate
//
//  Created by Quentin Eude on 22/09/2020.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct DrinkEntry: Codable {
    @DocumentID var id: String?
    @ServerTimestamp var time: Timestamp?
    var quantity: Double

    enum CodingKeys: String, CodingKey {
        case id
        case time
        case quantity
    }
}
