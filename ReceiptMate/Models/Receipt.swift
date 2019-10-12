//
//  Receipt.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/15/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

protocol ReceiptDelegate {
    func imageUpdated()
}

class Receipt : NSObject {
    
    struct Keys {
        static let userId = "user_id"
        static let date = "date"
        static let imgUrl = "img_url"
        static let store = "store"
        static let tags = "tags"
    }
    
    var delegate: ReceiptDelegate?
    var userId: String?
    var storeName: String?
    var date: Date?
    var receiptImage: UIImage?
    var tags: [String] = []
    
    init(dict: [String : Any]) {
        super.init()
        
        if let userId = dict[Keys.userId] as? String {
            self.userId = userId
        }
        
        if let storeName = dict[Keys.store] as? String {
            self.storeName = storeName
        }
        
        if let dateString = dict[Keys.date] as? String {
            let df = DateFormatter()
            df.dateStyle = .medium
            self.date = df.date(from: dateString)
        }
        
        if let receiptImageUrl = dict[Keys.imgUrl] as? String {
            
            // get img from url
            RMAPI.Storage.getImage(forUrl: receiptImageUrl) { (image) in
                if let image = image {
                    self.receiptImage = image
                    self.delegate?.imageUpdated()
                }
            }
        }
        
        if let tags = dict[Keys.tags] as? [String] {
            for tag in tags {
                self.tags.append(tag)
            }
        }
    }
    
}
