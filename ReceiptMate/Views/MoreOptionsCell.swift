//
//  MoreOptionsCell.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/9/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

protocol MoreOptionsDelegate {
    func optionSelected(data: MoreOptionsData?)
}

class MoreOptionsView: LUIView {
    
    var delegate: MoreOptionsDelegate?
    static let identifier = "more_options_cell"
    
    var iconImage: UIImage? {
        didSet {
            self.optionsBtn.image = self.iconImage?.template
        }
    }
    
    var optionText: String? {
        didSet {
            self.optionsBtn.text = self.optionText
        }
    }
    
    var moreOptionsData: MoreOptionsData? {
        didSet {
            self.iconImage = UIImage(named: self.moreOptionsData?.iconName ?? "")
            self.optionText = self.moreOptionsData?.optionText
        }
    }
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.square(to: Constants.ICON_SIZE)
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.color(for: .theme)
        return iv
    } ()
    
    private lazy var optionsBtn: LUIButton = {
        let btn = LUIButton(style: .outlined, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .regular, textFontStyle: .regular)
        
        return btn
    } ()
    
    private lazy var optionLabel = LUILabel(color: .darkText, fontSize: .regular, fontStyle: .regular)
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.delegate?.optionSelected(data: self.moreOptionsData)
        }
    }
    
    func setUpView() {
        self.addSubview(self.optionsBtn)
        self.fill(self.optionsBtn, padding: .none)
    }
    
    @objc func optionSelected() {
        
    }
}

extension MoreOptionsView: LUICellData {
    
    func setUpCell() {
        
//
//        self.contentView.addSubview(self.iconView)
//        self.contentView.addSubview(self.optionLabel)
//
//        self.contentView.centerY(self.iconView)
//        self.contentView.centerY(self.optionLabel)
//
//        self.contentView.left(self.iconView, fromLeft: true, paddingType: .none, withSafety: false)
//        self.iconView.right(self.optionLabel, fromLeft: true, paddingType: .regular, withSafety: false)
//        self.contentView.right(self.optionLabel, fromLeft: false, paddingType: .none, withSafety: false)
    }
    
    func formatCell(for data: Any) {
        if let optionData = data as? MoreOptionsData {
            self.moreOptionsData = optionData
        }
    }
    
}
