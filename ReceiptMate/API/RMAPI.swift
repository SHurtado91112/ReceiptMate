//
//  RMAPI.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/19/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import Firebase

typealias RMSuccessCompletion = (Bool, String?) -> Void
typealias RMReceiptCompletion = ([Receipt]?, String?) -> Void
typealias RMImageCompletion = (UIImage?) -> Void
typealias RMImageUploadCompletion = (String?) -> Void

class RMAPI {
    
    class Authentication {
        
        static func signUpUserFor(email: String, password: String, completion: @escaping RMSuccessCompletion) {
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
                            fallthrough
                        default:
                            // TODO: find ways to handle bad errros
                            completion(false, "Invalid credentials.")
                            break
                    
                    }
                    
                } else {
                    completion(true, nil) // all good
                }
                
            }
        }
        
        static func logInUserFor(email: String, password: String, completion: @escaping RMSuccessCompletion) {
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                
                if let error = error as NSError?, let authError = AuthErrorCode(rawValue: error.code) {
                    
                    switch authError {
                        case .invalidEmail:
                            completion(false, "The email you entered is not in a correct format.")
                            break
                        case .wrongPassword:
                            completion(false, "The password you entered was wrong.")
                            break
                        case .appNotAuthorized:
                            fallthrough
                        case .invalidUserToken:
                            fallthrough
                        default:
                            // TODO: find ways to handle bad errros
                            completion(false, "Invalid credentials.")
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
    
    class Database {
        static let db = Firestore.firestore()
        static var df: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .none
            return df
        } ()
        private struct Collections {
            static let Receipt = "Receipt"
        }
        
        static func getReceipts(forUser userId: String, completion: @escaping RMReceiptCompletion) {
            
            self.db.collection(Collections.Receipt).whereField(Receipt.Keys.userId, isEqualTo: userId).getDocuments { (query, error) in
                
                if let error = error as NSError?, let dbError = FirestoreErrorCode(rawValue: error.code) {
                    print("Firestore error: \(dbError.rawValue)")
                    completion(nil, "We couldn't retrieve your receipts at the moment.")
                } else if let query = query {

                    var receipts: [Receipt] = []
                    for doc in query.documents {
                        receipts.append(Receipt(dict: doc.data()))
                    }
                    completion(receipts, nil)
                    
                } else {
                    print("Unknown error in get Receipts")
                }
            }
        }
        
        static func createReceipt(_ receipt: Receipt, completion: @escaping RMSuccessCompletion) {
            
            if let userId = RMUser.shared?.uid, let date = RMAPI.Database.df.string(for: receipt.date), let store = receipt.storeName {
                
                RMAPI.Storage.uploadImage(receipt.receiptImage) { (url) in
                    if let url = url {
                        
                        self.db.collection(Collections.Receipt).addDocument(data:[
                            Receipt.Keys.userId: userId,
                            Receipt.Keys.date: date,
                            Receipt.Keys.store: store,
                            Receipt.Keys.tags: receipt.tags,
                            Receipt.Keys.imgUrl: url
                        ]) { (error) in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                                completion(false, "We weren't able to upload the receipt")
                            } else {
                                completion(true, nil)
                            }
                        }
                        
                    } else {
                        completion(false, "We weren't able to upload the receipt's image")
                    }
                }
            }
        }
        
    }
    
    class Storage {
        static let db = Firebase.Storage.storage()
        static let mb_max_size: Int64 = 1 * 1024 * 1024
        
        static func getImage(forUrl url: String, completion: @escaping RMImageCompletion) {
            let reference = db.reference(forURL: url)
            
            reference.getData(maxSize: self.mb_max_size) { (data, error) in
                if let error = error as NSError? {
                    print("Error: \(error)")
                } else if let data = data {
                    completion(UIImage(data: data))
                } else {
                    print("Unknown error")
                }
            }
        }
        
        static func uploadImage(_ image: UIImage?, completion: @escaping RMImageUploadCompletion) {
            let reference = db.reference().child("\(UUID().uuidString).jpeg")
            if let data = image?.jpegReduced(to: self.mb_max_size) {
                
                // Upload the file
                let _ = reference.putData(data, metadata: nil) { (metadata, error) in
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("Error uploading image: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        // You can also access to download URL after upload.
                        reference.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                // Uh-oh, an error occurred!
                                print("Error downloading image url: \(error?.localizedDescription ?? "")")
                                return
                            }
                            
                            completion(downloadURL.absoluteString)
                        }
                    }
                }
                
            }
        }
    }
    
}
