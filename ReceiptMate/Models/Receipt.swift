//
//  Receipt.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/15/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

class Receipt : NSObject {
    
    var storeName : String?
    var date : Date?
    var receiptImage : UIImage?
    var tags : [String] = []
    
    init(dict: [String : Any]) {
        
        if let storeName = dict["store_name"] as? String {
            self.storeName = storeName
        }
        
        if let dateString = dict["date"] as? String {
            let df = DateFormatter()
            df.dateStyle = .medium
            self.date = df.date(from: dateString)
        }
        
        self.receiptImage = UIImage(named: "receipt_sample")
//        if let receiptImageUrl = dict["img_url"] as? String {
//            
//            // get img from url
//        }
        
        if let tags = dict["tags"] as? [String] {
            for tag in tags {
                self.tags.append(tag)
            }
        }
    }
    
}
