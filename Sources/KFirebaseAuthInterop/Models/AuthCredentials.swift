//
//  AuthCredentials.swift
//  KFirebaseAuthInterop
//
//  Created by Michelle Raouf on 08/05/2025.
//

import Foundation

@objc public class AuthCredentials: NSObject {
    @objc public var idToken: String
    @objc public var accessToken: String
    @objc public var provider: AuthProvider

    @objc public init(idToken: String, accessToken: String, provider: AuthProvider) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.provider = provider
    }
}
