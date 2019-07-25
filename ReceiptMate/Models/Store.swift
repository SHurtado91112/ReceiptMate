//
//  Store.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/15/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

class Store : NSObject {
    
    static let nameKey = "name"
    static let brandKey = "brand"
    static let receiptsKey = "receipts"
    
    var name : String?
    var brand : UIImage?
    var receipts : [Receipt] = []
    
    init(name: String?, brandUrl: String?) {
        self.name = name
        
        if let brandUrl = brandUrl {
            // get that brand photo
        }
    }
}
