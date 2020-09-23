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

class DrinkEntryViewModel: ObservableObject {
    @Published var drinkEntries: [DrinkEntry] = []
    let dbRef = Firestore.firestore()

    func readAllDrinkEntries() {
        
    }
}
