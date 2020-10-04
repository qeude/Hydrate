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
    let date = Date()
    let calendar = Calendar.current
    let startTime: Date

    init(authState: AuthenticationState) {
        self.authState = authState
        startTime = calendar.startOfDay(for: self.date)

        self.readUser()
        self.readDrinkEntries()
    }

    @Published var user: DbUser?
    @Published var quantityDrinkedToday: Int = 0
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
        if let authUser = authState.loggedInUser {
            database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .whereField("time", isGreaterThanOrEqualTo: startTime)
                .whereField("time", isLessThanOrEqualTo: Date())
                .order(by: "time", descending: true)
                .addSnapshotListener { (snapshot, _) in
                    self.quantityDrinkedToday = 0
                    snapshot?.documents.forEach { documentSnapshot in
                        if let drinkEntry = try? documentSnapshot.data(as: DrinkEntry.self) {
                            self.quantityDrinkedToday += drinkEntry.quantity
                        }
                    }
                }
        }

    }
}
