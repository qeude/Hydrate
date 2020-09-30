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
        self.readDrinkEntries()
    }
    @Published var user: DbUser?
    @Published var drinkEntries: [DrinkEntry] = []

    let database = Firestore.firestore()

    func readUser() {
        if let authUser = authState.loggedInUser {
            database.collection("users").document(authUser.uid).addSnapshotListener { (documentSnapshot, _) in
                guard let user = try? documentSnapshot?.data(as: DbUser.self) else {
                    return
                }

                self.user = user
            }
        }
    }

    func readDrinkEntries() {
        // FIXME: should maybe don't get everything here, but maybe just information about the current day
        if let authUser = authState.loggedInUser {
            database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .order(by: "time", descending: true)
                .addSnapshotListener { (snapshot, _) in
                    self.drinkEntries = []
                    snapshot?.documents.forEach { documentSnapshot in
                        if let drinkEntry = try? documentSnapshot.data(as: DrinkEntry.self) {
                            self.drinkEntries.append(drinkEntry)
                        }
                    }
                }
        }

    }
}
