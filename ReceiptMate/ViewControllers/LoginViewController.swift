//
//  LoginViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class LoginViewController: LUIViewController {
    
    lazy var titleLabel : LUILabel = {
        let label = LUILabel(color: .theme, fontSize: .title, fontStyle: .bold)
        
        self.addView(label)
        self.centerX(label)
        self.descriptionLabel.top(label, fromTop: false, paddingType: .regular, withSafety: false)
        
        return label
    } ()
    
    lazy var descriptionLabel : LUILabel = {
        let label = LUILabel(color: .intermidiateText, fontSize: .regular, fontStyle: .italics)
        
        self.addView(label)
        self.center(label)
        
        return label
    } ()
    
    lazy var loginButton : LUIButton = {
        let button = LUIButton(style: .filled, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .large, textFontStyle: .regular)
        button.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        
        self.addView(button)
        self.centerX(button)
        self.descriptionLabel.bottom(button, fromTop: true, paddingType: .large, withSafety: false)
        
        return button
    } ()
    
    func setUpViews() {
        
        self.titleLabel.text = "Receipt Mate"
        self.descriptionLabel.text = "Your favorite receipt book."
        
        self.loginButton.text = "Let's get started"
        self.loginButton.onClick(sender: self, selector: #selector(self.login))
        
    }
    
    @objc private func login() {
        let receiptTableVC = ReceiptTableViewController(cellType: StoreCell.self, cellIdentifier: "store_cell")
        self.push(to: receiptTableVC)
    }

}
