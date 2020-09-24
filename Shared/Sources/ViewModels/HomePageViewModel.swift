//
//  DrinkEntryViewModel.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class HomePageViewModel: ObservableObject {
    var authState: AuthenticationState

    init(authState: AuthenticationState) {
        self.authState = authState
        self.readUser()
    }
    @Published var user: DbUser? = nil
    @Published var drinkEntries: [DrinkEntry] = []

    let db = Firestore.firestore()

    func readUser() {
        if let authUser = authState.loggedInUser {
            db.collection("users").document(authUser.uid).addSnapshotListener { (documentSnapshot, error) in
                guard let user = try? documentSnapshot?.data(as: DbUser.self) else {
                    return
                }

                self.user = user
            }
        }
    }
}
