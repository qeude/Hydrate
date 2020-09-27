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
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Image.iconTransparentBackground
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    Text(L10n.App.name)
                        .font(.largeTitle)
                        .bold()
                }
                if !authState.isAuthenticating {
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
