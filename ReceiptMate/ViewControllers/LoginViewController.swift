//
//  LoginViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI
import FirebaseAuth

fileprivate protocol _RMLoginDelegate {
    func authenticatedUser()
}

fileprivate class _RMLoginViewController: LUIViewController, RMLoginViewDelegate {
    
    var delegate: _RMLoginDelegate?
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
    
    // MARK: - RMLoginViewDelegate
    
    func fieldsForEventRegistering(textFields: [UIResponder]) {
        LUIKeyboardManager.shared.setTextFields(textFields, forController: self)
    }
    
    func otherLoginModeRequested() {
        
        let nextMode = !self.forLogin
        let nav = self.navigation
        
        let authVC = _RMLoginViewController()
        authVC.forLogin = nextMode
        authVC.delegate = self.delegate
        
        self.pop()
        
        nav?.push(to: authVC)
        
    }
    
    func basicValidationPassedForUser(email: String, password: String, signingUp: Bool) {
        
        if signingUp {
            
            LUIActivityIndicatorView.shared.present(withStyle: .small, from: self)
            RMAPI.Authentication.signUpUserFor(email: email, password: password) { (success, errMessage) in
                LUIActivityIndicatorView.shared.dismiss()
                
                if success {
                    self.delegate?.authenticatedUser()
                } else {
                    UIAlertController.presentAlert(title: "Something went wrong", message: errMessage ?? "", viewController: self)
                }
                
            }
            
        } else {
            
            LUIActivityIndicatorView.shared.present(withStyle: .small, from: self)
            RMAPI.Authentication.logInUserFor(email: email, password: password) { (success, errMessage) in
                LUIActivityIndicatorView.shared.dismiss()
                
                if success {
                    self.delegate?.authenticatedUser()
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
        let label = LUILabel(color: .intermediateText, fontSize: .regular, fontStyle: .italics)
        
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
    
    var authStateHandler: AuthStateDidChangeListenerHandle?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.authStateHandler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                // User is signed in.
                // ...
                print("User, \(user?.email ?? ""), signed in.")
                RMUser.setSharedUser(user)
                self.goToHomePage()
            } else {
                // No user is signed in.
                // ...
                if let presentedVC = self.presentedViewController {
                    self.popToRoot()
                    presentedVC.dismiss(animated: true, completion: nil)
                }
            }
        })
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
        logInViewController.delegate = self
        logInViewController.forLogin = true
        self.push(to: logInViewController)
    }
    
    @objc private func signUp() {
        let signUpViewController = _RMLoginViewController()
        signUpViewController.delegate = self
        signUpViewController.forLogin = false
        self.push(to: signUpViewController)
    }

    private func goToHomePage() {
        let receiptTableVC = ReceiptTableViewController(cellType: StoreCell.self, cellIdentifier: StoreCell.identifier)
        self.presentNavigation(receiptTableVC)
    }
}

extension LoginViewController: _RMLoginDelegate {
    func authenticatedUser() {
        print("User Authenticated")
    }
}
