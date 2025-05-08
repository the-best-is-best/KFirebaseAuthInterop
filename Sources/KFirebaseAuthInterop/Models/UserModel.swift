// UserModel.swift
// KFirebaseAuthInterop
//
// Created by Michelle Raouf on 06/05/2025.
//

import Foundation
import FirebaseAuth

@objc public class UserMetaDataModel: NSObject {
    @objc public var creationTime: Double
    @objc public var lastSignInTime: Double

    @objc public init(creationTime: Double, lastSignInTime: Double) {
        self.creationTime = creationTime
        self.lastSignInTime = lastSignInTime
    }
}

@objc public class UserModel: NSObject {
    @objc public var uid: String
    @objc public var email: String?
    @objc public var displayName: String?
    @objc public var phoneNumber: String?
    @objc public var photoURL: String?
    @objc public var isAnonymous: Bool
    @objc public var isEmailVerified: Bool
    @objc public var metaData: UserMetaDataModel?

    @objc public init(
        uid: String,
        email: String?,
        displayName: String?,
        phoneNumber: String?,
        photoURL: String?,
        isAnonymous: Bool,
        isEmailVerified: Bool,
        metaData: UserMetaDataModel?
    ) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        self.photoURL = photoURL
        self.isAnonymous = isAnonymous
        self.isEmailVerified = isEmailVerified
        self.metaData = metaData
    }
}

func fromFirebaseUser(_ user: User) -> UserModel {
    let metaDataModel = UserMetaDataModel(
        creationTime: user.metadata.creationDate?.timeIntervalSince1970 ?? 0,
        lastSignInTime: user.metadata.lastSignInDate?.timeIntervalSince1970 ?? 0
    )
    
    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoURL: user.photoURL?.absoluteString,
        isAnonymous: user.isAnonymous,
        isEmailVerified: user.isEmailVerified,
        metaData: metaDataModel
    )
}
