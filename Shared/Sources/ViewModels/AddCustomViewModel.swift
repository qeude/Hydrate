//
//  AddCustomViewModel.swift
//  Hydrate
//
//  Created by Quentin Eude on 30/11/2020.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class AddCustomViewModel: ObservableObject {
    let database = Firestore.firestore()

    var authState: AuthenticationState?

    func start(authState: AuthenticationState) {
        self.authState = authState
    }

    func addDrinkEntry(quantity: String) {
        if let authUser = authState?.loggedInUser {
            guard let quantity = Double(quantity) else {
                print("convertion error")
                return
            }
            //FIXME: should display error
            _ = try? database
                .collection("users")
                .document(authUser.uid)
                .collection("drink-entries")
                .addDocument(from: DrinkEntry(time: Timestamp.init(date: Date()), quantity: quantity))
        }
    }
}
