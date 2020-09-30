//
//  AuthenticationState.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import Foundation
import Combine
import FirebaseAuth
import AuthenticationServices
import FirebaseFirestore
import FirebaseFirestoreSwift

enum LoginOption {
    //    case signInWithApple
    case emailAndPassword(email: String, password: String)
}

class AuthenticationState: NSObject, ObservableObject {

    @Published var loggedInUser: User?
    @Published var isAuthenticating = false
    @Published var error: NSError?

    static let shared = AuthenticationState()

    private let auth = Auth.auth()
    fileprivate var currentNonce: String?

    func listenUser() {
        auth.addStateDidChangeListener { _, user in
            if let user = user {
                self.loggedInUser = user
            } else {
                self.loggedInUser = nil
            }
        }
    }

    func login(with loginOption: LoginOption) {
        self.isAuthenticating = true
        self.error = nil

        switch loginOption {
        case let .emailAndPassword(email, password):
            handleSignInWith(email: email, password: password)
        }
    }

    func signup(email: String, password: String, passwordConfirmation: String, firstname: String) {
        guard password == passwordConfirmation else {
            self.error = NSError(domain: "",
                                 code: 9210,
                                 userInfo: [NSLocalizedDescriptionKey: "Password and confirmation does not match"])
            return
        }

        self.isAuthenticating = true
        self.error = nil
        auth.createUser(withEmail: email, password: password) { auth, error in
            self.handleAuthResultCompletion(firstname: firstname, auth: auth, error: error)
        }
    }

    private func handleSignInWith(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { auth, error in
            self.handleAuthResultCompletion(auth: auth, error: error)
        }
    }

    private func handleAuthResultCompletion(firstname: String? = nil, auth: AuthDataResult?, error: Error?) {
        DispatchQueue.main.async {
            self.isAuthenticating = false
            if let user = auth?.user {
                self.loggedInUser = user

                let docRef = Firestore.firestore().collection("users").document(user.uid)
                docRef.getDocument { (document, _) in
                    if let email = user.email,
                       let firstname = firstname,
                       document == nil || !(document?.exists ?? true) {
                        _ = try? Firestore.firestore()
                            .collection("users")
                            .document(user.uid)
                            .setData(from: DbUser(id: user.uid, firstname: firstname, email: email))
                    }
                }
            } else if let error = error {
                self.error = error as NSError
            }
        }

    }

    func signout() {
        do {
            try auth.signOut()
            loggedInUser = nil
        } catch {
            print(error)
        }
    }
}
