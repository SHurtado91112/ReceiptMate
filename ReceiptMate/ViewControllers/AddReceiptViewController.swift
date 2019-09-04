//
//  AddReceiptViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/2/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

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
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    } ()
    private lazy var dateField: RMTextField = {
        let field = RMTextField()
        field.subtitle = "Date"
        field.placeholder = "Jun 7, 2019"
        field.field.inputView = self.datePicker
        return field
    } ()
    
    func setUpViews() {
        self.title = "Add New Receipt"
        self.addView(contentView)
        self.fill(self.contentView, padding: .regular)
        
        self.contentView.addArrangedSubview(contentView: storeField)
        self.contentView.addArrangedSubview(contentView: dateField)
    }
    
}
