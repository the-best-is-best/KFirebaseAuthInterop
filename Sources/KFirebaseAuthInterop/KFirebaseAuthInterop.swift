// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import FirebaseAuth
import Firebase


@objc
public class KFirebaseAuthInterop: NSObject {
    
    @objc
    public override init() {
        super.init()
    }
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    private var idTokenChangedListenerHandle: AuthStateDidChangeListenerHandle?

    @objc public func addListenerAuthStateChange(completion: @escaping (UserModel?) -> Void) {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                completion(fromFirebaseUser(user))
            } else {
                completion(nil)
            }
        }
    }

    
    @objc public func removeListenerAuthStateChange() {
            if let listenerHandle = authStateListenerHandle {
                Auth.auth().removeStateDidChangeListener(listenerHandle)
                authStateListenerHandle = nil
            }
        }
    
    @objc public func addListenerIdTokenChanged(completion: @escaping (UserModel?) -> Void) {
        idTokenChangedListenerHandle = Auth.auth().addIDTokenDidChangeListener { auth, user in
            if let user = user {
                completion(fromFirebaseUser(user))
            } else {
                completion(nil)
            }
        }
    }

    @objc public func removeListenerIdTokenChanged() {
        if let listenerHandle = idTokenChangedListenerHandle {
            Auth.auth().removeIDTokenDidChangeListener(listenerHandle)
            idTokenChangedListenerHandle = nil
        }
    }



    @objc public  func signInAnonymously(completion: @escaping (UserModel?, NSError?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(nil, error as NSError)
            } else {
                let model = fromFirebaseUser(authResult!.user)
                completion(model, nil)
            }
        }
    }

    
    
    @objc public func createUserWithEmailAndPassword(email: String, password: String, completion: @escaping (UserModel?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let user = authResult?.user else {
                completion(nil, NSError(domain: "CreateUserError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user returned"]))
                return
            }
            completion(fromFirebaseUser(user), nil)
        }
    }


    @objc
    public func signInWithEmail(_ email: String, password: String, completion: @escaping (UserModel?, NSError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                // Create a UserModel with user data
                let userModel = fromFirebaseUser(user)
                completion(userModel, nil)
            } else {
                completion(nil, error as NSError?)
            }
        }
    }
    
    @objc public func updatePassword(newPassword: String, completion: @escaping (NSError?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "FirebaseAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }

        user.updatePassword(to: newPassword) { error in
            completion(error as NSError?)
        }
    }

    
    @objc public func confirmPasswordReset(code: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().confirmPasswordReset(withCode: code, newPassword: newPassword) { error in
            completion(error)
        }
    }
    
    @objc public func setLanguageCodeLocale(languageCode: String) {
        Auth.auth().languageCode = languageCode
    }
    
    @objc public func getLanguageCodeLocale() -> String? {
        return Auth.auth().languageCode
    }

    
    @objc public func updateProfile(displayName: String?, photoURL: URL?, completion: @escaping (Error?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.photoURL = photoURL
        
        changeRequest?.commitChanges { error in
            completion(error)
        }
    }
    
    @objc public func isLinkEmail(email: String, completion: @escaping (Bool, Error?) -> Void) {
        let isLink = Auth.auth().isSignIn(withEmailLink: email)
        completion(isLink, nil)
    }
    
    
    @objc public func applyActionWithCode(code: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().applyActionCode(code) { error in
            completion(error)
        }
    }
    
    @objc public func checkActionWithCode(code: String, completion: @escaping (ActionCodeResultWrapper?) -> Void) {
        Auth.auth().checkActionCode(code) { result, error in
            if let error = error {
                // Return error if something went wrong
                completion(ActionCodeResultWrapper(result: nil, error: error as NSError))
            } else if let result = result {
                // Directly access the operation's raw value if it's an enum
                let operation = result.operation // Assuming `operation()` gives us an enum
                
                // Map the operation to ActionCodeResult based on its raw value
                let actionCodeResult = ActionCodeResult.fromOperation(operation, email: result.email, previousEmail: result.previousEmail)
                
                // Converting ActionCodeResult to its raw value (if it's an enum)
                let resultNumber = NSNumber(value: actionCodeResult.rawValue)
                
                // Returning the result wrapped in ActionCodeResultWrapper
                completion(ActionCodeResultWrapper(result: resultNumber, error: nil))
            } else {
                // Handle case where result is nil
                let unknownError = NSError(domain: "Unknown", code: 0, userInfo: nil)
                completion(ActionCodeResultWrapper(result: nil, error: unknownError))
            }
        }
    }
   
    
    @objc public func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error as NSError?)
        }
    }
    
    @objc public func deleteCurrentUser(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "FirebaseAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
            return
        }

        user.delete { error in
            completion(error as NSError?)
        }
    }




    @objc public func logout(completion: @escaping (NSError?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }

    @objc
    public func getCurrentUser() -> UserModel? {
        if let user = Auth.auth().currentUser {
            let userModel = fromFirebaseUser(user)
            return userModel
        }
        return nil
    }
    
    @objc public func sendOtp(
        phoneNumber: String,
        onCodeSent: @escaping (_ verificationId: String) -> Void,
        onCodeSentFailed: @escaping (_ error: NSError) -> Void
    ) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                onCodeSentFailed(error as? NSError ?? NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
                return
            }
            
            if let verificationID = verificationID {
                onCodeSent(verificationID)
            }
        }
    }

    @objc public func verifyOtp(
        verificationId: String,
        otpCode: String,
        onVerificationCompleted: @escaping (_ user: UserModel) -> Void,
        onVerificationFailed: @escaping (_ error: NSError) -> Void
    ) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: otpCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                onVerificationFailed(error as NSError)
                return
            }

            if let user = authResult?.user {
                onVerificationCompleted(fromFirebaseUser(user))
            }
        }
    }

}
