//
//  ActionCodeResultWrapper.swift
//  KFirebaseAuthInterop
//
//  Created by Michelle Raouf on 07/05/2025.
//

import Foundation

@objc public class ActionCodeResultWrapper: NSObject {
    @objc public var result: NSNumber?  // Represents ActionCodeResult as a number
    @objc public var error: NSError?    // Error is now an NSError object

    @objc public init(result: NSNumber?, error: NSError?) {
        self.result = result
        self.error = error
    }
}
