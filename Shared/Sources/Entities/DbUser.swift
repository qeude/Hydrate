//
//  User.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct DbUser: Codable {
    @DocumentID var id: String?
    @ServerTimestamp var time: Timestamp?
    var firstname: String
    var email: String
    var dailyGoal: Int? = 1500

    enum CodingKeys: String, CodingKey {
        case id
        case time
        case firstname
        case email
        case dailyGoal
    }
}
