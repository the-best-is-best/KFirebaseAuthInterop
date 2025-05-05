// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import FirebaseAuth

@objc
public class KFirebaseAuthInterop: NSObject {
    
    @objc
    public override init() {
        super.init()
    }

    /// Sign in using email and password.
    /// - Parameters:
    ///   - email: User email.
    ///   - password: User password.
    ///   - completion: Completion handler with UID or error.
    @objc
    public func signInWithEmail(_ email: String, password: String, completion: @escaping (NSString?, NSError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let uid = authResult?.user.uid {
                completion(uid as NSString, nil)
            } else {
                completion(nil, error as NSError?)
            }
        }
    }

    /// Sign out the current user.
    /// - Returns: NSError if sign out fails, otherwise nil.
    @objc
    public func logout(completion: @escaping (NSError?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }

    /// Get current logged-in user's UID.
    /// - Returns: UID string or nil.
    @objc
    public func getCurrentUserId() -> NSString? {
        return Auth.auth().currentUser?.uid as NSString?
    }
}
