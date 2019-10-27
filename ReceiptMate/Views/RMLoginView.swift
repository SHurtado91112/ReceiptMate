//
//  RMLoginView.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/19/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

protocol RMLoginViewDelegate {
    func basicValidationPassedForUser(email: String, password: String, signingUp: Bool)
    func otherLoginModeRequested()
}

class RMLoginView: LUIView {
    
    var forLogin: Bool = false {
        didSet {
            self.confirmField.isHidden = self.forLogin
            
            self.statusLabel.text = self.forLogin ? "Welcome back!" : "Let's get started!"
            
            self.submitBtn.text = self.forLogin ? "Log in" : "Sign up"
            
            self.otherModeBtn.text = self.forLogin ? "Don't have an account? Sign up!" : "Already have an account? Log in!"
            
            let fields: [UIResponder] = self.forLogin ? [self.emailField.field, self.passwordField.field] : [self.emailField.field, self.passwordField.field,  self.confirmField.field]
            LUIKeyboardManager.shared.setTextFields(fields)
        }
    }
    
    var delegate: RMLoginViewDelegate?
    
    private var email: String? {
        return self.emailField.field.text
    }
    
    private var password: String? {
        return self.passwordField.field.text
    }
    
    private var confirmPassword: String? {
        return self.confirmField.field.text
    }
    
    private lazy var fieldContentView: LUIStackView = {
        let sv = LUIStackView(padding: .regular)
        return sv
    } ()
    
    private lazy var statusLabel: LUILabel = {
        let label = LUILabel(color: .darkText, fontSize: .regular, fontStyle: .italics)
        return label
    } ()
    
    private lazy var emailField: RMTextField = {
        let field = RMTextField(direction: .vertical)
        field.placeholder = "receipt@mate.com"
        field.subtitle = "Enter email"
        field.field.keyboardType = .emailAddress
        field.field.autocapitalizationType = .none
        field.field.errorSpace = .small
        
        field.field.errorValidator = {
            (text) in
            
            if let text = text, !text.isEmpty {
                field.field.errorString = "Please enter a valid email address."
                return self.isValidEmail(emailStr: text)
            } else {
                field.field.errorString = "Please enter an email address."
                return false
            }
            
        }
        
        return field
    } ()
    
    private lazy var passwordField: RMTextField = {
        let field = RMTextField(direction: .vertical)
        field.placeholder = "password123"
        field.subtitle = "Enter password"
        field.field.isSecureTextEntry = true
        field.field.autocapitalizationType = .none
        field.field.errorSpace = .small
        
        field.field.errorValidator = {
            (text) in
            
            field.field.errorString = "Please enter a password."
            return !(text?.isEmpty ?? true)
        }
        
        return field
    } ()
    
    private lazy var confirmField: RMTextField = {
        let field = RMTextField(direction: .vertical)
        field.placeholder = "password123"
        field.subtitle = "Confirm Password"
        field.field.isSecureTextEntry = true
        field.field.autocapitalizationType = .none
        field.field.errorSpace = .small
        
        field.field.errorValidator = {
            (text) in
            
            if let text = text, !text.isEmpty {
                field.field.errorString = "Passwords must match."
                return text == self.passwordField.text
            } else {
                field.field.errorString = "Please confirm the password you entered."
                return false
            }
        }
        
        return field
    } ()
    
    private lazy var submitBtn: LUIButton = {
        let btn = LUIButton(style: .filled, affirmation: true, negation: false, raised: true, paddingType: .regular, fontSize: .large, textFontStyle: .bold)
        btn.onClick(sender: self, selector: #selector(self.submitPressed))
        return btn
    } ()
    
    private lazy var otherModeBtn: LUIButton = {
        let btn = LUIButton(style: .none, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .regular, textFontStyle: .regular)
        btn.onClick(sender: self, selector: #selector(self.otherModeRequested))
        return btn
    } ()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func setUpView() {
        
        self.addSubview(self.fieldContentView)
        self.fieldContentView.addArrangedSubview(contentView: self.statusLabel, fill: true)
        self.fieldContentView.addArrangedSubview(contentView: self.emailField, fill: true)
        self.fieldContentView.addArrangedSubview(contentView: self.passwordField, fill: true)
        self.fieldContentView.addArrangedSubview(contentView: self.confirmField, fill: true)
        
        self.fieldContentView.addPadding(.regular)
        self.fieldContentView.addArrangedSubview(contentView: self.submitBtn, fill: true)
        self.fieldContentView.addArrangedSubview(contentView: self.otherModeBtn, fill: true)
        
        self.fill(self.fieldContentView, padding: .regular, withSafety: true)
    }
    
    private func validate() -> Bool {
        
        var valid = false
        if self.forLogin {
            
            valid = self.emailField.field.validate() &&
                    self.passwordField.field.validate()
            
        } else { // for signing up
            
            valid = self.emailField.field.validate() &&
                    self.passwordField.field.validate() &&
                    self.confirmField.field.validate()
            
        }
        
        return valid
    }
    
    @objc private func submitPressed() {
        
        if !self.validate() {
            return
        }
        
        guard let email = self.email else { return }
        guard let password = self.password else { return }
        
        self.delegate?.basicValidationPassedForUser(email: email, password: password, signingUp: !self.forLogin)
    }
    
    @objc private func otherModeRequested() {
        self.delegate?.otherLoginModeRequested()
    }
    
    private func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }

}
