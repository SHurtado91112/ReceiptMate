//
//  RMTextField.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/2/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class RMTextField: LUIView {

    var subtitle: String = "" {
        didSet {
            self.subtitleLabel.text = self.subtitle
            self.subtitleLabel.sizeToFit()
        }
    }
    
    var placeholder: String = "" {
        didSet {
            self.textField.placeholder = self.placeholder
            self.textField.sizeToFit()
        }
    }
    
    var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
            self.textField.sizeToFit()
        }
    }
    
    var field: LUITextField {
        return self.textField
    }
    
    private var direction: NSLayoutConstraint.Axis?
    
    private lazy var textField: LUITextField = {
        let field = LUITextField(paddingType: .regular, fontSize: .regular, textFontStyle: .regular, placeholderFontStyle: .italics)
        field.borderStyle = .roundedRect
        return field
    } ()
    
    private lazy var subtitleLabel: LUILabel = {
        let label = LUILabel(color: .theme, fontSize: .regular, fontStyle: .bold)
        return label
    } ()

    private lazy var fieldStack: LUIStackView = {
        self.subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        var stack: LUIStackView?
        if self.direction == .horizontal {
            stack = LUIStackView(padding: .regular)
            
            stack?.addArrangedSubview(contentViews: [self.subtitleLabel, self.textField], fill: true, direction: self.direction ?? .horizontal, distribution: UIStackView.Distribution.fill)
        } else {
            stack = LUIStackView(padding: .none)
            
            stack?.addArrangedSubview(contentViews: [self.subtitleLabel, self.textField], fill: true, direction: self.direction ?? .vertical, distribution: .fill, alignment: .fill)
        }
        
        return stack ?? LUIStackView(padding: .none)
    } ()
    
    required init() {
        super.init()
    }
    
    required convenience init(direction: NSLayoutConstraint.Axis) {
        self.init()
        self.direction = direction
        self.deferredSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let minFieldFrame: CGFloat = 73.0 // fixed variable dependent on padding of stack view
        if self.direction == .horizontal {
            self.fieldStack.height(to: self.subtitleLabel.heightAnchor, constraintOperator: .greaterThan)
            self.fieldStack.height(to: self.textField.heightAnchor, constraintOperator: .greaterThan)
        } else {
            self.fieldStack.height(to: minFieldFrame, constraintOperator: .greaterThan)
        }
        
    }
    
    func setUpView() {
        if let _ = self.direction {
            self.deferredSetUp()
        }
    }
    
    private func deferredSetUp() {
        
        self.backgroundColor = .clear
        self.addSubview(self.fieldStack)
        self.fill(self.fieldStack, padding: .none)
        self.field.clipsToBounds = false
        self.fieldStack.clipsToBounds = false
        self.clipsToBounds = false
    }
    
}
