//
//  HomeView.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authState: AuthenticationState

    var body: some View {
        Button("Sign out", action: signoutTapped)
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
