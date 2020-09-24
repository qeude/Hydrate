//
//  HomeView.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var authState: AuthenticationState

    var body: some View {
        Observe(obj: HomePageViewModel(authState: authState)) { homeViewModel in
            NavigationView {
                VStack {
                    Button("Sign out", action: signoutTapped)
                }.navigationTitle("Hello \(homeViewModel.user?.firstname ?? "")")
            }
        }
    }

    private func signoutTapped() {
        authState.signout()
    }
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
