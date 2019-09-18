//
//  RMDateField.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/17/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

class RMDateField: RMTextField {

    // Public
    var date: Date {
        get {
            return self.datePicker.date
        }
    }
    
    var dateStr: String {
        return self.dateFormatter.string(from: self.date)
    }
    
    var dateStyle: DateFormatter.Style = .full {
        didSet {
            self.dateFormatter.dateStyle = self.dateStyle
        }
    }
    
    var timeStyle: DateFormatter.Style = .full {
        didSet {
            self.dateFormatter.timeStyle = self.timeStyle
        }
    }
    
    // Private
    private let dateFormatter = DateFormatter()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    } ()
    
    override func setUpView() {
        super.setUpView()
        
        self.field.inputView = self.datePicker
        self.datePicker.addTarget(self, action: #selector(self.dateValueChanged), for: .valueChanged)
        self.field.addTarget(self, action: #selector(self.editingBegin), for: .editingDidBegin)
    }
    
    private func setDate() {
        self.field.text = self.dateStr
    }
    
    // selectors
    @objc private func editingBegin() {
        self.setDate()
    }
    
    @objc private func dateValueChanged() {
        self.setDate()
    }

}
