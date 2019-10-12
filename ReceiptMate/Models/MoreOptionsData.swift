//
//  MoreOptionsData.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/9/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import Foundation

typealias MoreOptionsBlock = ()->Void

class MoreOptionsData: NSObject {
    
    var iconName: String?
    var optionText: String?
    var action: MoreOptionsBlock?
    
    init(iconName: String, optionText: String, action: @escaping MoreOptionsBlock) {
        self.iconName = iconName
        self.optionText = optionText
        self.action = action
    }
}
