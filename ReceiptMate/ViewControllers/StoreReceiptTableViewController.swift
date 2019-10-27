//
//  StoreReceiptTableViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 8/25/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class StoreReceiptTableViewController: LUITableViewController {

    var store: Store? {
        didSet {
            if let store = self.store {
                self.title = store.name
                self.receipts = store.receipts
            }
        }
    }
    
    var receipts: [Receipt] = [] {
        didSet {
            self.receipts.sort { $0.date! < $1.date! }
            self.rowData = self.receipts
        }
    }
    
    private let previewer = LUIPreviewManagerViewController()
    
    override func setUpViews() {
        super.setUpViews()
        
        if let brand = self.store?.brand {
            let brandImageView = UIImageView(image: brand)
            brandImageView.contentMode = .scaleAspectFit
            brandImageView.width(to: Constants.ICON_SIZE)
            brandImageView.height(to: Constants.ICON_SIZE)
            
            let item = UIBarButtonItem(customView: brandImageView)
            self.navigationItem.rightBarButtonItems = [item]
        }
        
        // feux footer
        let safetyInsets = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -safetyInsets, right: 0)
        self.tableView.insetsContentViewsToSafeArea = false
    }

    override open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let safetyInsets = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        let width = self.view.frame.width
        let padding = LUIPaddingManager.shared.padding(for: .regular)
        
        let footerBlocker = UIView(frame: CGRect(x: 0, y: 0, width: width, height: padding + safetyInsets))
        footerBlocker.backgroundColor = self.view.backgroundColor
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: width, height: padding))
        footer.backgroundColor = UIColor.color(for: .theme)
        footerBlocker.addSubview(footer)
        
        return footerBlocker
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let safetyInsets = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        let padding = LUIPaddingManager.shared.padding(for: .regular)
        return padding + safetyInsets
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let receiptCell = cell as? ReceiptCell {
            receiptCell.delegate = self
        }
        
        return cell
    }
    
}

extension StoreReceiptTableViewController: ReceiptCellDelegate {
    
    func tagSelected(_ tag: String) {
//        self.navigationItem.searchController?.searchBar.text = tag
//        self.navigationItem.searchController?.isActive = true
    }
    
    func receiptSelected(_ receipt: Receipt?) {
        if let receiptImage = receipt?.receiptImage {
            self.previewer.previewContent = [receiptImage]
            
            self.navigation?.present(self.previewer.dissmissableNavigation(), animated: true, completion: nil)
        }
    }
}
