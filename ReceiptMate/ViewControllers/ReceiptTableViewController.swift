//
//  ReceiptTableViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class ReceiptTableViewController: LUITableViewController {
    var receipts : [Receipt] = []
    var stores : [Store] = []
    
    private let previewer = LUIPreviewManagerViewController()
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchBarAppear(false)
        self.unregisterForObservers()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBarAppear(true)
        
        self.registerForObservers()
    }
    
    func searchBarAppear(_ appeared: Bool) {
        if let searchbar = self.navigationItem.searchController?.searchBar {
            UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast)) {
                searchbar.alpha = appeared ? 1.0 : 0.0
            }
        }
    }
    
    private func registerForObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeRegistered), name: Notification.Name.RMReceiptAdded, object: nil)
    }
    
    private func unregisterForObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.RMReceiptAdded, object: nil)
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        self.title = "Receipt Mate"
        
        let moreBtn = LUIButton(style: .none, affirmation: false, negation: false, raised: false, paddingType: .none, fontSize: .regular, textFontStyle: .regular)
        moreBtn.image = UIImage(named: Assets.moreIcon)?.template
        moreBtn.square(to: Constants.ICON_SIZE)
        moreBtn.onClick(sender: self, selector: #selector(self.presentMoreOptions))
        
        let rightItems: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addReceipt)),
            UIBarButtonItem(customView: moreBtn)
        ]
        self.navigationItem.setRightBarButtonItems(rightItems, animated: false)
        
        self.setUpForSearch { (item, text, scope) -> Bool in
            switch scope {
            case 0:
                if let store = item as? Store {
                    return store.name?.lowercased().removingPunctuation.contains(text.lowercased().removingPunctuation) ?? false
                }
            case 1:
                if let receipt = item as? Receipt {
                    
                    var containsContent = false
                    
                    // by store
                    containsContent = receipt.storeName?.lowercased().removingPunctuation.contains(text.lowercased().removingPunctuation) ?? false
                    
                    // tag
                    if !containsContent {
                        containsContent = (receipt.tags.first(where: { (tag) -> Bool in
                            return tag.lowercased().contains(text.lowercased())
                        }) != nil)
                    }
                    
                    // date
                    if !containsContent {
                        let receiptDate = receipt.date ?? Date()
                        containsContent = receiptDate.month.lowercased().contains(text.lowercased()) ||
                        receiptDate.year.lowercased().contains(text.lowercased()) ||
                        receiptDate.day.lowercased().contains(text.lowercased()) ||
                        receiptDate.weekday.lowercased().contains(text.lowercased())
                    }
                    
                    return containsContent
                }
            default:
                return false
            }
            return false
        }
        self.loadData()
        
        // feux footer
        let safetyInsets = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -safetyInsets, right: 0)
        self.tableView.insetsContentViewsToSafeArea = false

    }
    
    public func loadData() {
        
        var storeMap : [String : Store] = [:]
        
        self.receipts = []
        self.stores = []
        
        LUIActivityIndicatorView.shared.present(withStyle: .large, from: self)
        
        // get receipt for user
        if let userId = RMUser.shared?.uid {
            RMAPI.Database.getReceipts(forUser: userId) { (receipts, errorMessage) in
                
                LUIActivityIndicatorView.shared.dismiss()
                
                if let errorMessage = errorMessage {
                    UIAlertController.presentAlert(title: "Sorry", message: errorMessage, actionText: "Okay", viewController: self)
                } else if let receipts = receipts {
                    for receipt in receipts {
                        receipt.delegate = self
                        
                        let storeName = receipt.storeName ?? ""
                        self.receipts.append(receipt)
                        
                        var store : Store?
                        if (storeMap.index(forKey: storeName) != nil) {
                            store = storeMap[storeName]
                        } else {
                            store = Store(name: storeName, brandUrl: nil)
                            guard let store = store else { return }
                            storeMap[storeName] = store
                            self.stores.append(store)
                        }
                        
                        store?.receipts.append(receipt)
                        
                        if let url = Store.storeUrls[storeName] {
                            UIImage.image(for: url, completion: { (image, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    store?.brand = image
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                   
                    self.receipts.sort { $0.date! < $1.date! }
                    self.stores.sort { $0.name! < $1.name! }
                    
                    self.rowData = self.stores
                }
            }
        }
        
        self.scopeData = [
            "By Store", "By Receipt"
        ]
        self.delegate = self
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
        
        if let storeCell = cell as? StoreCell {
            storeCell.delegate = self
        }
        
        return cell
    }

    // MARK: - Selectors
    @objc private func changeRegistered() {
        self.loadData()
    }
    
    @objc private func presentMoreOptions() {
        let moreOptionsVC = MoreOptionsViewController(optionData: [
            MoreOptionsData(iconName: Assets.signOutIcon, optionText: "Sign me out", action: {
                LUIPopOverViewController.current?.dismiss()
                self.signOutRequested()
                
            }),
            MoreOptionsData(iconName: Assets.aboutIcon, optionText: "About this app", action: {
                LUIPopOverViewController.current?.dismiss()
                self.push(to: AboutViewController())
            }),
        ])
        
        self.popOver(moreOptionsVC)
    }
    
    private func signOutRequested() {
        UIAlertController.presentActionSheet(title: "Signing out?", message: "If you want to sign out of Receipt Mate, please continue.", withOptions: [
            UIAlertAction(title: "Sign out", style: .destructive, handler: { (action) in
                
                RMAPI.Authentication.signOut()
//                self.dismiss(animated: true, completion: nil)
                
            }),
            UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        ], viewController: self)
    }
    
    @objc private func addReceipt() {
        let addReceiptVC = AddReceiptViewController()
        
        var storeNames: [String] = []
        
        // stores we read
        for store in self.stores {
            if let storeName = store.name {
                storeNames.append(storeName)
            }
        }
        
        // stores that are stored by default
        for (storeName, _) in Store.storeUrls {
            if !storeNames.contains(storeName) {
                storeNames.append(storeName)
            }
        }
        
        addReceiptVC.storeSuggestions = storeNames.sorted()
        let modalVC = addReceiptVC.dismissableModalViewController()
        self.present(modalVC)
    }
}

extension ReceiptTableViewController: LUISearchTableDelegate {

    func selectedScopeDidChange(index: Int) {
        switch index {
            case 0:
                self.rowData = self.stores
                self.resetCells(for: StoreCell.self, cellIdentifier: StoreCell.identifier)
                break
            case 1:
                self.rowData = self.receipts
                self.resetCells(for: ReceiptCell.self, cellIdentifier: ReceiptCell.identifier)
                break
            default:
                break
        }
    }

}

extension ReceiptTableViewController: ReceiptCellDelegate {

    func tagSelected(_ tag: String) {
        self.navigationItem.searchController?.searchBar.text = tag
        self.navigationItem.searchController?.isActive = true
    }
    
    func receiptSelected(_ receipt: Receipt?) {
        if let receiptImage = receipt?.receiptImage {
            self.previewer.previewContent = [receiptImage]
            self.previewer.previewDelegate = self
            
            self.navigation?.present(self.previewer.dismissableModalViewController(), animated: true, completion: nil)
        }
    }
}

extension ReceiptTableViewController: StoreCellDelegate {
    
    func storeSelected(_ store: Store?) {
        let storeVC = StoreReceiptTableViewController(cellType: ReceiptCell.self, cellIdentifier: ReceiptCell.identifier)
        storeVC.store = store
        self.push(to: storeVC)
    }
    
}

extension ReceiptTableViewController: LUIPreviewDelegate {
    
    func pageChanged() {
        // TODO: for when multiple pages involved
    }
    
    func dismissedPreview() {
        self.viewDidAppear(true) // TODO: check if this is okay to do
    }
}

extension ReceiptTableViewController: ReceiptDelegate {
    func imageUpdated() {
        self.tableView.reloadData()
    }
}
