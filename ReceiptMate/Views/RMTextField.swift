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
        }
    }
    
    var placeholder: String = "" {
        didSet {
            self.textField.placeholder = self.placeholder
        }
    }
    
    var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    var field: LUITextField {
        return self.textField
    }
    
    private var direction: NSLayoutConstraint.Axis = .horizontal
    
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
        let stack = LUIStackView(padding: .none)
        
        self.subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        if self.direction == .horizontal {
            stack.addArrangedSubview(contentViews: [self.subtitleLabel, self.textField], fill: true, direction: self.direction, distribution: UIStackView.Distribution.fill)
        } else {
            
            stack.addArrangedSubview(contentViews: [self.subtitleLabel, self.textField], fill: true, direction: self.direction, distribution: .fill, alignment: .fill)
        }
        
        return stack
    } ()
    
    required convenience init(direction: NSLayoutConstraint.Axis = .horizontal) {
        self.init(frame: .zero)
        self.direction = direction
        self.setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        self.backgroundColor = .clear
        self.addSubview(self.fieldStack)
        self.fill(self.fieldStack, padding: .none)
        self.field.clipsToBounds = false
        self.fieldStack.clipsToBounds = false
        self.clipsToBounds = false
    }
    
}
