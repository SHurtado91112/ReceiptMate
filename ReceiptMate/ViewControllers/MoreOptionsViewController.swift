//
//  MoreOptionsViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/11/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class MoreOptionsViewController: LUIViewController {
    
    private var optionData: [MoreOptionsData] = []
    private lazy var contentView: LUIStackView = {
        let sv = LUIStackView(padding: .small)
        self.addView(sv)
        self.fill(sv)
        return sv
    } ()
    
    required init(optionData: [MoreOptionsData]) {
        super.init(nibName: nil, bundle: nil)
        
        self.optionData = optionData
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpViews() {
        self.view.backgroundColor = UIColor.color(for: .lightBackground)
        
        var lastDivider: UIView?
        for option in self.optionData {
            let optionView = MoreOptionsView()
            optionView.moreOptionsData = option
            optionView.delegate = self
            
            self.contentView.addArrangedSubview(contentView: optionView, fill: true)
            lastDivider = self.contentView.addDivider()
        }
        lastDivider?.removeFromSuperview()
        
        self.contentView.fitStack()
    }

}

extension MoreOptionsViewController: MoreOptionsDelegate {
    func optionSelected(data: MoreOptionsData?) {
        data?.action?()
    }
}
