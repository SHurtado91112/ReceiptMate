//
//  AddReceiptViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/2/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI
import WSTagsField

class AddReceiptViewController: LUIViewController {
    
    private lazy var contentView: LUIStackView = {
        let stackView = LUIStackView(padding: .regular)
        return stackView
    } ()
    
    private lazy var storeField: RMTextField = {
        let field = RMTextField()
        field.subtitle = "Store"
        field.placeholder = "Target"
        return field
    } ()
    
    private lazy var dateField: RMDateField = {
        let field = RMDateField()
        field.subtitle = "Date"
        field.placeholder = "Jun 7, 2019"
        field.dateStyle = .medium
        field.timeStyle = .none
        return field
    } ()
    
    private lazy var tagField: WSTagsField = {
        let tv = WSTagsField()
        
        let paddingManager = LUIPaddingManager.shared
        tv.layoutMargins = paddingManager.paddingRect(for: .small)//UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tv.contentInset = paddingManager.paddingRect(for: .regular)
        tv.spaceBetweenLines = paddingManager.padding(for: .regular)
        tv.spaceBetweenTags = paddingManager.padding(for: .regular)
        tv.font = tv.font?.substituteFont.withSize(.regular)
        
        tv.backgroundColor = UIColor.color(for: .intermidiateBackground).withAlphaComponent(0.2)
        tv.tintColor = UIColor.color(for: .theme).withAlphaComponent(0.6)
        tv.textColor = UIColor.color(for: .lightText)
        tv.fieldTextColor = UIColor.color(for: .darkText)
        tv.selectedColor = UIColor.color(for: .theme)
        tv.selectedTextColor = UIColor.color(for: .lightText)
        tv.delimiter = ""
        tv.isDelimiterVisible = false
        tv.placeholderColor = UIColor.color(for: .intermidiateText)
        tv.placeholderAlwaysVisible = false
        tv.returnKeyType = .next
        tv.acceptTagOption = .return
        tv.cornerRadius = Constants.ROUNDED_CORNER_CONSTANT
        tv.layer.cornerRadius = Constants.ROUNDED_CORNER_CONSTANT
//
//        let toolbar = LUIKeyboardToolBar()
//        tv.inputFieldAccessoryView = toolbar
//        toolbar.keyboardDelegate = self
//
        tv.height(to: 48.0, constraintOperator: .greaterThan)
        return tv
    } ()
    
    func setUpViews() {
        self.title = "Add New Receipt"
        self.addView(self.contentView)
        self.view.fill(self.contentView, padding: .none, withSafety: true)
        self.contentView.addPadding(.large)
        self.contentView.addArrangedSubview(contentView: self.storeField, fill: true)
        self.contentView.addArrangedSubview(contentView: self.dateField, fill: true)
        self.contentView.addArrangedSubview(contentView: self.tagField, fill: true)
        let fields: [UIResponder] = [
            self.storeField.field,
            self.dateField.field
        ]
        
        
        LUIKeyboardManager.shared.setTextFields(fields)
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.tagField.beginEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        self.tagField.endEditing()
        }
    }
}
//
//// KNOWN TO APPLY TO ONLY WSTagsField
//extension AddReceiptViewController: LUIKeyboardToolBarDelegate {
//
//    func dismissRequested() {
//        self.view.endEditing(true)
//    }
//
//    func canGoToPrevious() -> Bool {
//        return true
//    }
//
//    func canGoToNext() -> Bool {
//        return false
//    }
//
//    func previousFieldRequested() {
//        //
//    }
//
//    func nextFieldRequested() {
//        //
//    }
//
//}
