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
    @Published var quantityDrinkedToday: Double = 0
    @Published var drinkEntries: [DrinkEntry] = []
    @Published var progress: CGFloat = 0
    @Published var barchartEntries: [(String, Double)] = []

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

            database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .whereField("time", isGreaterThanOrEqualTo: startTime - 7.days)
                .whereField("time", isLessThanOrEqualTo: endTime)
                .addSnapshotListener { (snapshot, _) in
                    self.barchartEntries = []
                    var entries: [Date: Double] = [:]
                    for dayNumber in (0...7).reversed() {
                        let components = Calendar.current.dateComponents([.year, .month, .day],
                                                                         from: self.startTime - dayNumber.days)
                        if let date = Calendar.current.date(from: components) {
                            entries[date] = 0.0
                        }
                    }
                    snapshot?.documents.forEach { documentSnapshot in
                        if let drinkEntry = try? documentSnapshot.data(as: DrinkEntry.self) {
                            if let drinkEntryDate = drinkEntry.time?.dateValue() {
                                let components = Calendar.current.dateComponents([.year, .month, .day],
                                                                                 from: drinkEntryDate)
                                if let date = Calendar.current.date(from: components),
                                   entries[date] != nil {
                                    entries[date]! += drinkEntry.quantity
                                }
                            }
                        }
                    }
                    self.barchartEntries = entries
                        .map { (key: Date, value: Double) -> (Date, Double) in
                            return (key, value)
                        }
                        .sorted { (t1, t2) -> Bool in
                            return t1.0.isBeforeDate(t2.0, granularity: .day)
                        }
                        .map { value -> (String, Double) in
                            return (value.0.weekdayName(.veryShort), value.1)
                        }
                }
        }
    }

    func addDrinkEntry(quantity: Double) {
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
