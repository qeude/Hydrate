//
//  HydrateApp.swift
//  Shared
//
//  Created by Quentin Eude on 21/09/2020.
//

import SwiftUI
import Firebase

@main
struct HydrateApp: App {
    var authState: AuthenticationState

    init() {
        FirebaseApp.configure()
        authState = AuthenticationState.shared

    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authState)
        }
    }
}
