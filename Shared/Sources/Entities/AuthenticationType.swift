//
//  AuthenticationType.swift
//  Hydrate
//
//  Created by Quentin Eude on 23/09/2020.
//

import Foundation
enum AuthenticationType: String {
    case login
    case signup

    var text: String {
        rawValue.capitalized
    }

    var assetBackgroundName: String {
        self == .login ? "login" : "signup"
    }

    var footerText: String {
        switch self {
            case .login:
                return "Not a member, signup"

            case .signup:
                return "Already a member? login"
        }
    }
}

extension NSError: Identifiable {
    public var id: Int { code }
}
