//
//  RMUser.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/8/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import FirebaseAuth

class RMUser {
    
    private init() {}
    
    static private(set) var shared: User?
    static func setSharedUser(_ user: User?) {
        self.shared = user
    }
    
}
