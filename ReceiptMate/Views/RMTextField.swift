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
    
    private lazy var textField: LUITextField = {
        let field = LUITextField(paddingType: .regular, fontSize: .regular, textFontStyle: .regular, placeholderFontStyle: .italics)
        return field
    } ()
    
    private lazy var subtitleLabel: LUILabel = {
        let label = LUILabel(color: .intermidiateText, fontSize: .regular, fontStyle: .bold)
        return label
    } ()

    private lazy var fieldStack: LUIStackView = {
        let stack = LUIStackView(padding: .regular)
        stack.addArrangedSubview(contentViews: [self.subtitleLabel, self.textField], fill: true, direction: .horizontal)
        return stack
    } ()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {
        self.addSubview(self.fieldStack)
        self.fill(self.fieldStack, padding: .none)
    }
    
}