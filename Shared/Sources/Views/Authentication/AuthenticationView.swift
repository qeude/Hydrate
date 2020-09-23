//
//  AuthenticationView.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI

struct AuthenticationView: View {

    @EnvironmentObject var authState: AuthenticationState
    @State var authType = AuthenticationType.login

    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Text("Hydrate").font(.largeTitle)
                if (!authState.isAuthenticating) {
                    AuthenticationFormView(authType: $authType)
                } else {
                    ProgressView()
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
