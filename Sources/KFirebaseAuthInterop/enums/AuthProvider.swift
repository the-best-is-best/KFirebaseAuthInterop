//
//  AuthProvider.swift
//  KFirebaseAuthInterop
//
//  Created by Michelle Raouf on 08/05/2025.
//

@objc public enum AuthProvider: Int {
    case google
    case facebook
    
    public func stringValue() -> String {
        switch self {
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
    
        default:
            return "Unknown"
        }
    }
}
