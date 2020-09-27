//
//  AuthenticationFormView.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import SwiftUI

struct AuthenticationFormView: View {
    @EnvironmentObject var authState: AuthenticationState

    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirmation: String = ""
    @State var firstname: String = ""

    var isEmailAuthenticationButtonDisabled: Bool {
        switch authType {
        case .login:
            return email.isEmpty || password.isEmpty
        case .signup:
            return email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty || firstname.isEmpty
        }
    }

    @Binding var authType: AuthenticationType

    var body: some View {
        VStack(spacing: 16) {
            #if os(iOS)
            if authType == .signup {
                TextField(L10n.Auth.Firstname.Textfield.placeholder, text: $firstname)
                    .disableAutocorrection(true)
                    .textContentType(.name)
                    .keyboardType(.default)
                    .autocapitalization(.words)
            }

            TextField(L10n.Auth.Email.Textfield.placeholder, text: $email)
                .disableAutocorrection(true)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            #elseif os(macOS)
            if authType == .signup {
                TextField(L10n.Auth.Firstname.Textfield.placeholder, text: $firstname)
                    .disableAutocorrection(true)
            }

            TextField(L10n.Auth.Email.Textfield.placeholder, text: $email)
                .disableAutocorrection(true)
            #endif
            SecureField(L10n.Auth.Password.Textfield.placeholder, text: $password)

            if authType == .signup {
                SecureField(L10n.Auth.Password.Confirmation.Textfield.placeholder, text: $passwordConfirmation)
            }

            Button(action: emailAuthenticationTapped) {
                Text(authType.text)
                    .font(.callout)
                    .frame(maxWidth: .infinity)

            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isEmailAuthenticationButtonDisabled)

            Button(action: footerButtonTapped) {
                Text(authType.footerText)
                    .font(.callout)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(16)
        .textFieldStyle(PrimaryTextFieldStyle())
        .alert(item: $authState.error) { error in
            Alert(title: Text(L10n.Common.error), message: Text(error.localizedDescription))
        }
    }

    private func emailAuthenticationTapped() {
        switch authType {
        case .login:
            authState.login(with: .emailAndPassword(email: email, password: password))
        case .signup:
            authState.signup(email: email,
                             password: password,
                             passwordConfirmation: passwordConfirmation,
                             firstname: firstname)
        }
    }

    private func footerButtonTapped() {
        clearFormField()
        authType = authType == .signup ? .login : .signup
    }

    private func clearFormField() {
        email = ""
        password = ""
        passwordConfirmation = ""
    }
}

struct AuthenticationFormView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationFormView(authType: .constant(.login))
    }
}
