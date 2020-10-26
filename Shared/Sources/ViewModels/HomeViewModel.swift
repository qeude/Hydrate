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

class HomeViewModel: ObservableObject {
    let database = Firestore.firestore()

    var authState: AuthenticationState?
    let date = Date()
    let calendar = Calendar.current
    let startOfToday: Date
    let endOfToday: Date

    @Published var user: DbUser?
    @Published var quantityDrinkedToday: Double = 0
    @Published var todayDrinkEntries: [DrinkEntry] = []
    @Published var progress: CGFloat = 0

    init() {
        self.startOfToday = calendar.startOfDay(for: self.date)
        self.endOfToday = calendar.startOfDay(for: self.date + 1.days)
    }

    func start(authState: AuthenticationState) {
        self.authState = authState

        self.readUser()
        self.readDrinkEntries()
    }

    func readUser() {
        if let authUser = authState?.loggedInUser {
            database.collection("users").document(authUser.uid).addSnapshotListener { (documentSnapshot, _) in
                guard let user = try? documentSnapshot?.data(as: DbUser.self) else {
                    return
                }

                self.user = user
            }
        }
    }

    func readDrinkEntries() {
        if let authUser = authState?.loggedInUser {
            database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .whereField("time", isGreaterThanOrEqualTo: startOfToday)
                .whereField("time", isLessThanOrEqualTo: endOfToday)
                .addSnapshotListener { (snapshot, _) in
                    self.quantityDrinkedToday = 0
                    self.todayDrinkEntries = []
                    snapshot?.documents.forEach { documentSnapshot in
                        if let drinkEntry = try? documentSnapshot.data(as: DrinkEntry.self) {
                            self.todayDrinkEntries.append(drinkEntry)
                            self.quantityDrinkedToday += drinkEntry.quantity
                            self.progress = CGFloat(self.quantityDrinkedToday) / CGFloat(self.user?.dailyGoal ?? 2000) * 100
                        }
                    }
                    self.todayDrinkEntries.sort { (d1, d2) -> Bool in
                        if let date1 = d1.time?.dateValue(),
                           let date2 = d2.time?.dateValue() {
                            return date1.isAfterDate(date2, granularity: .nanosecond)
                        } else {
                            return false
                        }
                    }
                }
        }
    }

    func addDrinkEntry(quantity: Double) {
        if let authUser = authState?.loggedInUser {
            //FIXME: should display error
            _ = try? database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .addDocument(from: DrinkEntry(time: Timestamp.init(date: Date()), quantity: quantity))
        }
    }

    func removeDrinkEntry(at offsets: IndexSet) {
        if let authUser = authState?.loggedInUser {
            let itemsToDelete = offsets.lazy.map { self.todayDrinkEntries[$0] }
            itemsToDelete.forEach { drinkEntry in
                if let id = drinkEntry.id {
                    database
                        .collection("users")
                        .document(authUser.uid)
                        .collection("drink-entries")
                        .document(id)
                        .delete()
                }
            }
        }
    }

    func resetDrinkEntriesForToday() {
        if let authUser = authState?.loggedInUser {
            database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .whereField("time", isGreaterThanOrEqualTo: startOfToday)
                .whereField("time", isLessThanOrEqualTo: endOfToday)
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
