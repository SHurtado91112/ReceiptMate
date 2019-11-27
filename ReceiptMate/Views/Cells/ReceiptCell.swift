//
//  ReceiptCell.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/21/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI
import WSTagsField

protocol ReceiptCellDelegate {
    func tagSelected(_ tag: String)
    func receiptSelected(_ receipt: Receipt?)
}

class ReceiptCell: LUITableCell {

    static var identifier = "receipt_cell"
    var action: (() -> Void)?
    
    lazy var storeLabel : LUILabel = {
        let label = LUILabel(color: .intermediateText, fontSize: .small, fontStyle: .regular)
        
        self.contentView.addSubview(label)
        
        self.dateLabel.bottom(label, fromTop: true, paddingType: .small, withSafety: false)
        self.contentView.left(label, fromLeft: true, paddingType: .regular, withSafety: false)
        self.tagView.top(label, fromTop: false, paddingType: .regular, withSafety: false, constraintOperator: .lessThan)
        
        
        return label
    } ()
    
    lazy var dateLabel : LUILabel = {
        let label = LUILabel(color: .darkText, fontSize: .regular, fontStyle: .regular)
        
        self.contentView.addSubview(label)
        self.contentView.top(label, fromTop: true, paddingType: .large, withSafety: false)
        self.contentView.left(label, fromLeft: true, paddingType: .regular, withSafety: false)
        
        return label
    } ()
    
    lazy var receiptImageView : UIImageView = {
        let iv = UIImageView(image: nil)
        iv.backgroundColor = .clear
        
        self.contentView.addSubview(iv)
        self.contentView.top(iv, fromTop: true, paddingType: .large, withSafety: false)
        self.contentView.right(iv, fromLeft: false, paddingType: .regular, withSafety: false)
        self.tagView.top(iv, fromTop: false, paddingType: .regular, withSafety: false, constraintOperator: .lessThan)
        
        iv.height(to: 80.0)
        iv.width(to: 60.0)
        iv.contentMode = .scaleAspectFill
        iv.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        iv.clipsToBounds = true
        
        return iv
    } ()
    
    
    lazy var tagView : WSTagsField = {
        let tv = WSTagsField()
        
        let paddingManager = LUIPaddingManager.shared
        tv.layoutMargins = paddingManager.paddingRect(for: .small)//UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tv.contentInset = paddingManager.paddingRect(for: .regular)
        tv.spaceBetweenLines = paddingManager.padding(for: .regular)
        tv.spaceBetweenTags = paddingManager.padding(for: .regular)
        tv.font = tv.font?.substituteFont.withSize(.regular)
        
        tv.backgroundColor = UIColor.color(for: .intermediateBackground).withAlphaComponent(0.2)
        tv.tintColor = UIColor.color(for: .theme).withAlphaComponent(0.6)
        tv.textColor = UIColor.color(for: .lightText)
        tv.fieldTextColor = UIColor.color(for: .darkText)
        tv.selectedColor = UIColor.color(for: .theme)
        tv.selectedTextColor = UIColor.color(for: .lightText)
        tv.delimiter = ""
        tv.isDelimiterVisible = false
        tv.placeholderColor = UIColor.color(for: .intermediateText)
        tv.placeholderAlwaysVisible = false
        tv.returnKeyType = .next
        tv.acceptTagOption = .return
        tv.cornerRadius = Constants.ROUNDED_CORNER_CONSTANT
        tv.layer.cornerRadius = Constants.ROUNDED_CORNER_CONSTANT
        
        let toolbar = LUIKeyboardToolBar()
        tv.inputFieldAccessoryView = toolbar
        toolbar.keyboardDelegate = self
        
        tv.onDidSelectTagView = { field, tag in
            let tagText = tag.displayText
            self.delegate?.tagSelected(tagText)
        }
        
        self.contentView.addSubview(tv)
        self.contentView.left(tv, fromLeft: true, paddingType: .regular, withSafety: false)
        self.contentView.right(tv, fromLeft: false, paddingType: .regular, withSafety: false)
        self.contentView.bottom(tv, fromTop: false, paddingType: .regular, withSafety: false, constraintOperator: .lessThan)
        
        tv.height(to: 48.0, constraintOperator: .greaterThan)

        return tv
    } ()
    
    
    var delegate: ReceiptCellDelegate?
    var receipt: Receipt? {
        didSet {
            guard let receipt = self.receipt else { return }
            let df = DateFormatter()
            df.dateStyle = .medium
            self.storeLabel.text = receipt.storeName
            self.dateLabel.text = df.string(from: receipt.date ?? Date())
            self.receiptImageView.image = receipt.receiptImage
            
            self.tagView.removeTags()
            for tag in receipt.tags {
                self.tagView.addTag(tag)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.delegate?.receiptSelected(self.receipt)
        }
    }
    
    func setUpCell() {
        // initialize if needed
    }
    
    func formatCell(for data: Any) {
        if let receipt = data as? Receipt {
            self.receipt = receipt
        }
    }
}

extension ReceiptCell: LUIKeyboardToolBarDelegate {
    
    func dismissRequested() {
        self.endEditing(true)
    }
    
    func canGoToPrevious() -> Bool {
        return false
    }
    
    func canGoToNext() -> Bool {
        return false
    }
    
    func previousFieldRequested() {
        //
    }
    
    func nextFieldRequested() {
        //
    }
    
    
}
