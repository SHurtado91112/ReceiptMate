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
    
    static let storeUrls: [String : String] = [
        "Target" : "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Target_Corporation_logo_%28vector%29.svg/1920px-Target_Corporation_logo_%28vector%29.svg.png",
        "Macy's" : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Macys_logo.svg/2880px-Macys_logo.svg.png",
        "Ross" : "https://upload.wikimedia.org/wikipedia/en/thumb/f/f7/Ross_Stores_logo.svg/2880px-Ross_Stores_logo.svg.png",
        "Best Buy" : "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Best_Buy_logo_2018.svg/2880px-Best_Buy_logo_2018.svg.png",
        "Marshalls" : "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Marshalls_Logo.svg/2880px-Marshalls_Logo.svg.png",
        "DSW" : "https://upload.wikimedia.org/wikipedia/commons/b/b4/DSW_Official_Logo.png",
        "TJ Maxx" : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/TJ_Maxx_Logo.svg/2880px-TJ_Maxx_Logo.svg.png",
        "Ulta" : "https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Ulta_Beauty_logo.svg/2880px-Ulta_Beauty_logo.svg.png"
    ]
    
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
