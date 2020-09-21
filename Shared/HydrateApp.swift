//
//  HydrateApp.swift
//  Shared
//
//  Created by Quentin Eude on 21/09/2020.
//

import SwiftUI

@main
struct HydrateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
