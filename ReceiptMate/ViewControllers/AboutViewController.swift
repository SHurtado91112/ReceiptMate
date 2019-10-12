//
//  AboutViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/11/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class AboutViewController: LUIViewController {
    
    private lazy var contentView: LUIStackView = {
        let sv = LUIStackView(padding: .regular)
        self.addView(sv)
        self.view.fill(sv, padding: .none, withSafety: true)
        return sv
    } ()
    
    private lazy var reasonLabel: LUILabel = {
        let label = LUILabel(color: .darkText, fontSize: .regular, fontStyle: .regular)
        label.doesWrap = true
        label.text = "This application was developed by Steven Hurtado, a twenty-something-year-old software engineer that has trouble keeping track of receipts. To make his and his wife's life easier, he decided to make Receipt Mate. Hopefully this helps!"
        return label
    } ()
    
    private lazy var creditsLabel: LUITextView = {
        let label = LUITextView(paddingType: .none, fontSize: .regular, textFontStyle: .regular)
        
        label.beginBuilding()
        label.addText("Credits to a number of icon assets used in this application go to ", textColor: .darkText)
        label.addLink("the icons8 team.", linkColor: UIColor.color(for: .theme), urlStr: "https://icons8.com")
        label.endBuilding()
        
        return label
    } ()
    
    func setUpViews() {
        self.title = "About"
        
        self.contentView.addPadding(.regular)
        self.contentView.addArrangedSubtitle("Who created this app?")
        self.contentView.addArrangedSubview(contentView: self.reasonLabel, fill: true)
        
        self.contentView.addPadding(.regular)
        self.contentView.addArrangedSubtitle("Credits")
        self.contentView.addArrangedSubview(contentView: self.creditsLabel, fill: true)
    }

}
