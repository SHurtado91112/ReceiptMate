//
//  RmAPI.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/19/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import Firebase

typealias RmSuccessCompletion = (Bool, String?) -> Void

class RMAPI {
    
    class Authentication {
        
        static func signUpUserFor(email: String, password: String, completion: @escaping RmSuccessCompletion) {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                
                if let error = error as NSError?, let authError = AuthErrorCode(rawValue: error.code) {
                    
                    switch authError {
                        case .invalidEmail:
                            completion(false, "The email you entered is not in a correct format.")
                            break
                        case .emailAlreadyInUse:
                            completion(false, "The email you entered is already attached to an account for Receipt Mate. Try to use a different email.")
                            break
                        case .weakPassword:
                            completion(false, "The password you entered is too weak. Try to make a stronger password.")
                            break
                        case .appNotAuthorized:
                            fallthrough
                        case .invalidUserToken:
                            // TODO: sign out
                            break
                        default:
                            // TODO: find ways to handle bad errros
                            break
                    
                    }
                    
                } else {
                    completion(true, nil) // all good
                }
                
            }
        }
        
        static func logInUserFor(email: String, password: String, completion: @escaping RmSuccessCompletion) {
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                
                if let error = error as NSError?, let authError = AuthErrorCode(rawValue: error.code) {
                    
                    switch authError {
                        case .invalidEmail:
                            completion(false, "The email you entered is not in a correct format.")
                            break
                        case .wrongPassword:
                            completion(false, "The credentials you entered were wrong.")
                            break
                        case .appNotAuthorized:
                            fallthrough
                        case .invalidUserToken:
                            // TODO: sign out
                            break
                        default:
                            // TODO: find ways to handle bad errros
                            break
                    }
                    
                } else {
                    completion(true, nil)
                }
                
            }
        }
        
        static func signOut() {
            do {
                try Auth.auth().signOut()
            }
            catch let e {
                print("Error: \(e.localizedDescription)")
            }
        }
        
    }
    
}
