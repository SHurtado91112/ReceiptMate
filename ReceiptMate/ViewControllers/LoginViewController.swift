//
//  LoginViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

fileprivate class _RMLoginViewController: LUIViewController, RMLoginViewDelegate {
    
    var forLogin: Bool = false {
        didSet {
            self.title = self.forLogin ? "Log In" : "Create Account"
            if let view = self.view as? RMLoginView {
                view.forLogin = self.forLogin
            }
        }
    }
    
    override func loadView() {
        let loginView = RMLoginView()
        loginView.delegate = self
        
        self.view = loginView
    }
    
    func setUpViews() {
        
    }
    
    private func goToHomePage() {
        let receiptTableVC = ReceiptTableViewController(cellType: StoreCell.self, cellIdentifier: StoreCell.identifier)
        self.present(LUINavigationViewController(rootVC: receiptTableVC))
    }
    
    // MARK: - RMLoginViewDelegate
    
    func basicValidationPassedForUser(email: String, password: String, signingUp: Bool) {
        
        if signingUp {
            
            RmAPI.Authentication.signUpUserFor(email: email, password: password) { (success, errMessage) in
                
                if success {
                    self.goToHomePage()
                } else {
                    UIAlertController.presentAlert(title: "Something went wrong", message: errMessage ?? "", viewController: self)
                }
                
            }
            
        } else {
            
            RmAPI.Authentication.logInUserFor(email: email, password: password) { (success, errMessage) in
                
                if success {
                    self.goToHomePage()
                } else {
                    UIAlertController.presentAlert(title: "Something went wrong", message: errMessage ?? "", viewController: self)
                }
                
            }
            
        }
        
    }
    
}

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
        let button = LUIButton(style: .filled, affirmation: false, negation: false, raised: true, paddingType: .regular, fontSize: .large, textFontStyle: .regular)
        button.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        
        self.addView(button)
        self.centerX(button)
        self.signUpButton.top(button, fromTop: false, paddingType: .regular, withSafety: false)
        self.view.left(button, fromLeft: true, paddingType: .large, withSafety: true)
        self.view.right(button, fromLeft: false, paddingType: .large, withSafety: false)
        
        return button
    } ()
    
    lazy var signUpButton : LUIButton = {
        let button = LUIButton(style: .outlined, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .regular, textFontStyle: .bold)
        button.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        
        self.addView(button)
        self.centerX(button)
        self.view.bottom(button, fromTop: false, paddingType: .large, withSafety: false)
        self.view.left(button, fromLeft: true, paddingType: .large, withSafety: true)
        self.view.right(button, fromLeft: false, paddingType: .large, withSafety: false)
        
        return button
    } ()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigation?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigation?.setNavigationBarHidden(false, animated: true)
        
        super.viewWillDisappear(animated)
    }
    
    func setUpViews() {
        
        self.titleLabel.text = "Receipt Mate"
        self.descriptionLabel.text = "Your favorite receipt book."
        
        self.loginButton.text = "Log in"
        self.loginButton.onClick(sender: self, selector: #selector(self.login))
        
        self.signUpButton.text = "New here?"
        self.signUpButton.onClick(sender: self, selector: #selector(self.signUp))
    }
    
    @objc private func login() {
        let logInViewController = _RMLoginViewController()
        logInViewController.forLogin = true
        self.push(to: logInViewController)
    }
    
    @objc private func signUp() {
        let signUpViewController = _RMLoginViewController()
        signUpViewController.forLogin = false
        self.push(to: signUpViewController)
    }

}
