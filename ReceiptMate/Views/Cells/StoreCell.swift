//
//  StoreCell.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/15/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

protocol StoreCellDelegate {
    func storeSelected(_ store: Store?)
}

class StoreCell: LUITableCell {
    
    static let identifier = "store_cell"
    lazy var storeLabel : LUILabel = {
        let label = LUILabel(color: .darkText, fontSize: .large, fontStyle: .bold)
        
        self.contentView.addSubview(label)
        self.contentView.top(label, fromTop: true, paddingType: .large, withSafety: false)
        self.contentView.left(label, fromLeft: true, paddingType: .regular, withSafety: false)
        
        return label
    } ()
    
    lazy var numberOfReceiptsLabel : LUILabel = {
        let label = LUILabel(color: .intermediateText, fontSize: .regular, fontStyle: .italics)
        
        self.contentView.addSubview(label)
        self.storeLabel.bottom(label, fromTop: true, paddingType: .regular, withSafety: false)
        self.contentView.left(label, fromLeft: true, paddingType: .regular, withSafety: false)
        self.contentView.bottom(label, fromTop: false, paddingType: .regular, withSafety: false, constraintOperator: .equal)
        
        return label
    } ()
    
    lazy var brandImageView : UIImageView = {
        let iv = UIImageView(image: nil)
        iv.backgroundColor  = UIColor.clear
        
        self.contentView.addSubview(iv)
        self.contentView.top(iv, fromTop: true, paddingType: .large, withSafety: false)
        self.contentView.right(iv, fromLeft: false, paddingType: .regular, withSafety: false)
        self.contentView.bottom(iv, fromTop: false, paddingType: .regular, withSafety: false, constraintOperator: .lessThan)
        
        iv.width(to: 100.0)
        iv.height(to: 75.0)
        iv.contentMode = .scaleAspectFit
        
        return iv
    } ()
 
    
    var delegate: StoreCellDelegate?
    var store: Store? {
        didSet {
            guard let store = self.store else { return }
            self.storeLabel.text = store.name
            self.brandImageView.image = store.brand
            self.numberOfReceiptsLabel.text = "\(store.receipts.count) receipt\(store.receipts.count == 1 ? "" : "s")"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.delegate?.storeSelected(self.store)
        }
    }
}

extension StoreCell: LUICellData {
    
    func setUpCell() {
        // initialize if needed
    }
    
    func formatCell(for data: Any) {
        if let store = data as? Store {
            self.store = store
        }
    }
    
}
