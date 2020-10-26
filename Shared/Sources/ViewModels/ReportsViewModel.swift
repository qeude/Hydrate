//
//  ReportViewModel.swift
//  Hydrate
//
//  Created by Quentin Eude on 26/10/2020.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftDate
import SwiftUI

class ReportsViewModel: ObservableObject {
    let database = Firestore.firestore()

    var authState: AuthenticationState?
    let date = Date()
    let calendar = Calendar.current
    let startOfToday: Date
    let endOfToday: Date

    @Published var user: DbUser?
    @Published var barchartEntries: [(String, Double)] = []
    @Published var barchartStartDate: Date
    @Published var barchartEndDate: Date

    init() {
        self.startOfToday = calendar.startOfDay(for: self.date)
        self.endOfToday = calendar.startOfDay(for: self.date + 1.days)
        self.barchartStartDate = startOfToday - 6.days
        self.barchartEndDate = startOfToday
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
                .whereField("time", isGreaterThanOrEqualTo: self.barchartStartDate)
                .whereField("time", isLessThanOrEqualTo: self.barchartEndDate)
                .addSnapshotListener { (snapshot, _) in
                    self.barchartEntries = []
                    var entries: [Date: Double] = [:]
                    for dayNumber in (0...6).reversed() {
                        let components = Calendar.current.dateComponents([.year, .month, .day],
                                                                         from: self.startOfToday - dayNumber.days)
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

    func getBarchartLabel() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "\(formatter.string(from: self.barchartStartDate)) - \(formatter.string(from: self.barchartEndDate))"
    }

    // swiftlint:disable shorthand_operator
    func setPreviousWeekBarchart() {
        self.barchartStartDate = self.barchartStartDate - 7.days
        self.barchartEndDate = self.barchartEndDate - 7.days
        self.readDrinkEntries()
    }

    // swiftlint:disable shorthand_operator
    func setNextWeekBarchart() {
        self.barchartStartDate = self.barchartStartDate + 7.days
        self.barchartEndDate = self.barchartEndDate + 7.days
        self.readDrinkEntries()
    }
}
