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
    private let storeUrls : [String : String] = [
        "Target" : "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Target_Corporation_logo_%28vector%29.svg/1920px-Target_Corporation_logo_%28vector%29.svg.png",
        "Macy's" : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Macys_logo.svg/2880px-Macys_logo.svg.png",
        "Ross" : "https://upload.wikimedia.org/wikipedia/en/thumb/f/f7/Ross_Stores_logo.svg/2880px-Ross_Stores_logo.svg.png",
        "Best Buy" : "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Best_Buy_logo_2018.svg/2880px-Best_Buy_logo_2018.svg.png",
        "Marshalls" : "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Marshalls_Logo.svg/2880px-Marshalls_Logo.svg.png",
        "DSW" : "https://upload.wikimedia.org/wikipedia/commons/b/b4/DSW_Official_Logo.png",
        "TJ Maxx" : "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/TJ_Maxx_Logo.svg/2880px-TJ_Maxx_Logo.svg.png",
        "Ulta" : "https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Ulta_Beauty_logo.svg/2880px-Ulta_Beauty_logo.svg.png"
    ]
    private let receiptJSON : [[String : Any]] = [
        [
            "store_name" : "Ross",
            "date" : "Jun 08, 2019",
            "tags" : ["return", "shirt", "towel"]
        ],
        [
            "store_name" : "Target",
            "date" : "Jan 04, 2019",
            "tags" : ["beats", "phone case"]
        ],
        [
            "store_name" : "Target",
            "date" : "Mar 21, 2019",
            "tags" : ["cat litter", "milk", "make up remover"]
        ],
        [
            "store_name" : "Target",
            "date" : "May 14, 2019",
            "tags" : ["couch", "cookies", "pizza cutter"]
        ],
        [
            "store_name" : "Target",
            "date" : "Nov 24, 2018",
            "tags" : ["shoes", "shirt", "switch"]
        ],
        [
            "store_name" : "Macy's",
            "date" : "May 15, 2019",
            "tags" : ["purse", "pot", "make up"]
        ],
        [
            "store_name" : "Ross",
            "date" : "Jun 04, 2019",
            "tags" : ["adidas", "shirt", "towel"]
        ],
    ]
    
    var receipts : [Receipt] = []
    var stores : [Store] = []
    
    private let previewer = LUIPreviewManagerViewController()
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchBarAppear(false)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBarAppear(true)
    }
    
    func searchBarAppear(_ appeared: Bool) {
        if let searchbar = self.navigationItem.searchController?.searchBar {
            UIView.animate(withDuration: TimeInterval.timeInterval(for: .fast)) {
                searchbar.alpha = appeared ? 1.0 : 0.0
            }
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        self.title = "Receipt Mate"
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
        
        for dict in self.receiptJSON {
            let receipt = Receipt(dict: dict)
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
            
            if let url = self.storeUrls[storeName] {
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
        
        self.scopeData = [
            "By Store", "By Receipt"
        ]
        self.delegate = self
        
        self.receipts.sort { $0.date! < $1.date! }
        self.stores.sort { $0.name! < $1.name! }
        
        self.rowData = self.stores
    }
    
    override open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let safetyInsets = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        let width = self.view.frame.width
        let padding = LUIPaddingManager.shared.padding(for: .regular)
        
        let footerBlocker = LUIView(frame: CGRect(x: 0, y: 0, width: width, height: padding + safetyInsets))
        footerBlocker.backgroundColor = self.view.backgroundColor
        
        let footer = LUIView(frame: CGRect(x: 0, y: 0, width: width, height: padding))
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
        self.navigation?.push(to: storeVC)
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
