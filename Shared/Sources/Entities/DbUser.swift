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
    var email: String

    enum CodingKeys: String, CodingKey {
        case id
        case time
        case email
    }
}
