//
//  SettingsViewModel.swift
//  Hydrate
//
//  Created by Quentin Eude on 14/10/2020.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftDate
import SwiftUI

class SettingsViewModel: ObservableObject {
    var authState: AuthenticationState?

    func start(authState: AuthenticationState) {
        self.authState = authState
        self.readUser()
    }

    @Published var user: DbUser?
    @Published var firstname: String = ""
    @Published var dailyGoal: Double = 0
    @Published var isLoaded = false

    let database = Firestore.firestore()

    func readUser() {
        if let authUser = authState?.loggedInUser {
            database.collection("users").document(authUser.uid).addSnapshotListener { (documentSnapshot, _) in
                guard let user = try? documentSnapshot?.data(as: DbUser.self) else {
                    return
                }

                self.user = user
                self.firstname = user.firstname
                self.dailyGoal = user.dailyGoal
                self.isLoaded = true
            }
        }
    }

    func saveSettings() {
        if let authUser = authState?.loggedInUser {
            self.user?.firstname = firstname
            self.user?.dailyGoal = dailyGoal
            try? database.collection("users").document(authUser.uid).setData(from: self.user)
        }
    }
}
