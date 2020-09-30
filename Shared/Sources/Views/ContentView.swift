//
//  ContentView.swift
//  Shared
//
//  Created by Quentin Eude on 21/09/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var authState: AuthenticationState
    @State var showSplashScreen = true

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            if authState.loggedInUser != nil && !showSplashScreen {
                HomeView()
            } else {
                AuthenticationView(authType: .login)
            }
        }
        .onAppear(perform: onAppear)
    }

    private func onAppear() {
        authState.listenUser()
        delaySplashScreen()
    }

    private func delaySplashScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showSplashScreen = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
