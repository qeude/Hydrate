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
    @Published var barchartMaxValue: Double = 2000
    @Published var barchartEntries: [(String, Double)] = []
    @Published var barchartStartDate: Date?
    @Published var barchartEndDate: Date?
    @Published var segmentedPickerPossibilities = BarchartDateGranularity.allCases
    @Published var selectedGranularity = 0 {
        didSet {
            if oldValue != selectedGranularity {
                self.initBarchartDates()
                self.readDrinkEntries()
            }
        }
    }

    init() {
        self.startOfToday = self.date.dateAtStartOf(.day)
        self.endOfToday = self.date.dateAtEndOf(.day)
    }

    func start(authState: AuthenticationState) {
        self.authState = authState

        self.initBarchartDates()
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
                .whereField("time", isGreaterThanOrEqualTo: self.barchartStartDate!)
                .whereField("time", isLessThanOrEqualTo: self.barchartEndDate!)
                .addSnapshotListener { (snapshot, _) in
                    self.barchartEntries = []
                    var entries = self.initEntries()
                    snapshot?.documents.forEach { documentSnapshot in
                        if let drinkEntry = try? documentSnapshot.data(as: DrinkEntry.self) {
                            entries = self.process(entry: drinkEntry, in: entries)
                        }
                    }
                    self.barchartEntries = self.calculate(entries: entries)
                }
        }
    }

    private func initEntries() -> [Date: Double] {
        var entries: [Date: Double] = [:]
        for number in (0...6).reversed() {
            let fromDate: Date
            switch self.segmentedPickerPossibilities[self.selectedGranularity] {
            case .annualy:
                fromDate = (self.barchartEndDate! - number.years).dateAtEndOf(.year)
                self.barchartMaxValue = 365 * (self.user?.dailyGoal ?? 2000)
            case .monthly:
                fromDate = (self.barchartEndDate! - number.months).dateAtEndOf(.month)
                self.barchartMaxValue = 31 * (self.user?.dailyGoal ?? 2000)
            case .daily:
                fromDate = self.barchartEndDate! - number.days
                self.barchartMaxValue = self.user?.dailyGoal ?? 2000
            }
            entries[fromDate] = 0.0
        }
        return entries
    }

    private func process(entry: DrinkEntry, in entries: [Date: Double]) -> [Date: Double] {
        var entries = entries
        if let drinkEntryDate = entry.time?.dateValue() {
            var granularity: Calendar.Component
            switch self.segmentedPickerPossibilities[self.selectedGranularity] {
            case .annualy:
                granularity = .year
            case .monthly:
                granularity = .month
            case .daily:
                granularity = .day
            }
            if entries[drinkEntryDate.dateAtEndOf(granularity)] != nil {
                entries[drinkEntryDate.dateAtEndOf(granularity)]! += entry.quantity
            } else {
                entries[drinkEntryDate.dateAtEndOf(granularity)] = entry.quantity
            }
        }
        return entries
    }

    private func calculate(entries: [Date: Double]) -> [(String, Double)] {
        return entries
            .map { (key: Date, value: Double) -> (Date, Double) in
                return (key, value)
            }
            .sorted { (t1, t2) -> Bool in
                switch self.segmentedPickerPossibilities[self.selectedGranularity] {
                case .annualy:
                    return t1.0.isBeforeDate(t2.0, granularity: .year)
                case .monthly:
                    return t1.0.isBeforeDate(t2.0, granularity: .month)
                case .daily:
                    return t1.0.isBeforeDate(t2.0, granularity: .day)

                }
            }
            .map { value -> (String, Double) in
                switch self.segmentedPickerPossibilities[self.selectedGranularity] {
                case .annualy:
                    return ("\(value.0.year)", value.1)
                case .monthly:
                    return (value.0.monthName(.veryShort), value.1)
                case .daily:
                    return (value.0.weekdayName(.veryShort), value.1)
                }
            }
    }

    private func initBarchartDates() {
        switch self.segmentedPickerPossibilities[self.selectedGranularity] {
        case .daily:
            self.barchartStartDate = startOfToday - 6.days
            self.barchartEndDate = endOfToday
        case .monthly:
            self.barchartStartDate = (startOfToday - 6.months).dateAtStartOf(.month)
            self.barchartEndDate = startOfToday.dateAtEndOf(.month)
        case .annualy:
            self.barchartStartDate = (startOfToday - 6.years).dateAtStartOf(.year)
            self.barchartEndDate = startOfToday.dateAtEndOf(.year)
        }
    }

    func getBarchartLabel() -> String {
        let formatter = DateFormatter()
        switch self.segmentedPickerPossibilities[self.selectedGranularity] {
        case .daily:
            formatter.dateStyle = .medium
        case .monthly:
            formatter.dateFormat = "MMM yyyy"
        case .annualy:
            formatter.dateFormat = "yyyy"
        }
        if let startDate = self.barchartStartDate,
           let endDate = self.barchartEndDate {
            return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        } else {
            return "... - ..."
        }
    }

    func setPreviousDateAreaBarchart() {
        switch self.segmentedPickerPossibilities[self.selectedGranularity] {
        case .daily:
            self.barchartStartDate = self.barchartStartDate! - 1.weeks
            self.barchartEndDate = self.barchartEndDate! - 1.weeks
        case .monthly:
            self.barchartStartDate = (self.barchartStartDate! - 6.months).dateAtStartOf(.month)
            self.barchartEndDate = (self.barchartEndDate! - 6.months).dateAtEndOf(.month)
        case .annualy:
            self.barchartStartDate = (self.barchartStartDate! - 6.years).dateAtStartOf(.year)
            self.barchartEndDate = (self.barchartEndDate! - 6.years).dateAtEndOf(.year)
        }
        self.readDrinkEntries()
    }

    func setNextDateAreaBarchart() {
        switch self.segmentedPickerPossibilities[self.selectedGranularity] {
        case .daily:
            self.barchartStartDate = self.barchartStartDate! + 1.weeks
            self.barchartEndDate = self.barchartEndDate! + 1.weeks
        case .monthly:
            self.barchartStartDate = self.barchartStartDate! + 6.months
            self.barchartEndDate = self.barchartEndDate! + 6.months
        case .annualy:
            self.barchartStartDate = self.barchartStartDate! + 6.years
            self.barchartEndDate = self.barchartEndDate! + 6.years
        }
        self.readDrinkEntries()
    }
}
