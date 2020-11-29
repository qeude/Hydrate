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
    @State var showSplashScreen = true

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Image.iconTransparentBackground
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100, alignment: .center)
                Text(L10n.App.name)
                    .font(.largeTitle)
                    .bold()
            }
            if !authState.isAuthenticating && !showSplashScreen {
                AuthenticationFormView(authType: $authType)
            } else if authState.isAuthenticating {
                ProgressView()
            }
        }
        .onAppear(perform: delaySplashScreen)
        .transition(.opacity)
    }

    private func delaySplashScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showSplashScreen = false
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
