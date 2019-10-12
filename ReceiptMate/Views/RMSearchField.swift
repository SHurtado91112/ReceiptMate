//
//  RMSearchField.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/19/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import LazyUI
import SearchTextField

fileprivate class _RMSearchTextField: SearchTextField {
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = LUIPaddingManager.shared.paddingRect(for: .regular)
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = LUIPaddingManager.shared.paddingRect(for: .regular)
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = LUIPaddingManager.shared.paddingRect(for: .regular)
        return bounds.inset(by: padding)
    }
    
}

class RMSearchField: LUIView {

    var subtitle: String = "" {
        didSet {
            self.subtitleLabel.text = self.subtitle
        }
    }
    
    var placeholder: String = "" {
        didSet {
            let text = self.placeholder
            guard let font = self.textField.font?.withStyle(.italics) else { return }
            let color = LUIThemeManager.shared.color(for: .intermidiateText)
            self.textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font : font
            ])
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
    
    var field: SearchTextField {
        return self.textField
    }
    
    private lazy var textField: _RMSearchTextField = {
        let field = _RMSearchTextField(frame: CGRect.zero)
        
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        // Modify current theme properties
        field.theme.font = field.theme.font.withSize(.regular)
        field.font = field.font?.withSize(.regular)
        
        field.theme.bgColor = UIColor.color(for: .lightBackground)
        field.theme.separatorColor = .clear
        
        // Set specific comparision options - Default: .caseInsensitive
        field.comparisonOptions = [.caseInsensitive]
        
        // Set the max number of results. By default it's not limited
        field.maxNumberOfResults = 5
        
        // You can also limit the max height of the results list
        field.maxResultsListHeight = 200
        
        // Customize the way it highlights the search string. By default it bolds the string
        field.highlightAttributes = [
            NSAttributedString.Key.backgroundColor: UIColor.color(for: .theme),
            NSAttributedString.Key.foregroundColor: UIColor.color(for: .lightText),
            NSAttributedString.Key.font: field.theme.font.withSize(.regular).withStyle(.bold)
        ]
        
        // Show the list of results as soon as the user makes focus - Default: false
        field.startVisible = true
        
        // Start filtering after an specific number of characters - Default: 0
        field.minCharactersNumberToStartFiltering = 0
        
        field.borderStyle = .roundedRect
        return field
    } ()
    
    private lazy var subtitleLabel: LUILabel = {
        let label = LUILabel(color: .theme, fontSize: .regular, fontStyle: .bold)
        return label
    } ()
    
    private lazy var fieldStack: LUIStackView = {
        let stack = LUIStackView(padding: .regular)
        
        self.subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stack.addArrangedSubview(contentViews: [self.subtitleLabel, self.textField], fill: true, direction: .horizontal, distribution: UIStackView.Distribution.fill)
        
        stack.height(to: self.subtitleLabel.heightAnchor, constraintOperator: .greaterThan)
        stack.height(to: self.textField.heightAnchor, constraintOperator: .greaterThan)
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
    
    func setUpView() {
        self.addSubview(self.fieldStack)
        self.fill(self.fieldStack, padding: .none)
    }

}
