//
//  ActionCodeResult.swift
//  KFirebaseAuthInterop
//
//  Created by Michelle Raouf on 07/05/2025.
//
import Foundation
import FirebaseAuth

@objc public enum ActionCodeResult: Int {
    case signInWithEmailLink
    case verifyEmail
    case recoverEmail
    case revertSecondFactorAddition
    case verifyBeforeChangeEmail

    public var description: String {
        switch self {
        case .signInWithEmailLink:
            return "Sign in with email link"
        case .verifyEmail:
            return "Verify email"
        case .recoverEmail:
            return "Recover email"
        case .revertSecondFactorAddition:
            return "Revert second factor addition"
        case .verifyBeforeChangeEmail:
            return "Verify before change email"
        }
    }

    public static func fromOperation(_ operation: ActionCodeOperation, email: String?, previousEmail: String?) -> ActionCodeResult {
        switch operation {
        case .passwordReset:
            return .signInWithEmailLink
        case .verifyEmail:
            return .verifyEmail
        case .recoverEmail:
            return .recoverEmail
        case .revertSecondFactorAddition:
            return .revertSecondFactorAddition
        case .verifyAndChangeEmail:
            return .verifyBeforeChangeEmail
        default:
            fatalError("Unknown operation: \(operation.rawValue)")
        }
    }
}
