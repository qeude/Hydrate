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
import SwiftDate
import SwiftUI

class HomePageViewModel: ObservableObject {
    var authState: AuthenticationState
    let date = Date()
    let calendar = Calendar.current
    let startTime: Date
    let endTime: Date

    init(authState: AuthenticationState) {
        self.authState = authState
        self.startTime = calendar.startOfDay(for: self.date)
        self.endTime = calendar.startOfDay(for: self.date + 1.days)

        self.readUser()
        self.readDrinkEntries()
    }

    @Published var user: DbUser?
    @Published var quantityDrinkedToday = 0
    @Published var drinkEntries: [DrinkEntry] = []
    @Published var progress: CGFloat = 0

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
                .whereField("time", isLessThanOrEqualTo: endTime)
                .addSnapshotListener { (snapshot, _) in
                    self.quantityDrinkedToday = 0
                    snapshot?.documents.forEach { documentSnapshot in
                        if let drinkEntry = try? documentSnapshot.data(as: DrinkEntry.self) {
                            self.quantityDrinkedToday += drinkEntry.quantity
                            self.progress = CGFloat(self.quantityDrinkedToday) / CGFloat(self.user?.dailyGoal ?? 2000) * 100
                        }
                    }
                }
        }
    }

    func addDrinkEntry(quantity: Int) {
        if let authUser = authState.loggedInUser {
            //FIXME: should display error
            _ = try? database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .addDocument(from: DrinkEntry(time: Timestamp.init(date: Date()), quantity: quantity))
        }
    }

    func resetDrinkEntriesForToday() {
        if let authUser = authState.loggedInUser {
            database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .whereField("time", isGreaterThanOrEqualTo: startTime)
                .whereField("time", isLessThanOrEqualTo: endTime)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        querySnapshot?.documents.forEach { document in
                            document.reference.delete()
                        }
                    }
                }
        }
    }
}
