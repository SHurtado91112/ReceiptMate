//
//  MoreOptionsView.swift
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
            
            if let imageView = self.optionsBtn.imageView {
                imageView.square(to: Constants.ICON_SIZE)
                self.optionsBtn.centerY(imageView)
            }
            
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
            self.optionsBtn.height(to: Constants.BUTTON_SIZE)
        }
    }
    
    private lazy var optionsBtn: LUIButton = {
        let btn = LUIButton(style: .none, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .regular, textFontStyle: .regular)
        btn.textColor = UIColor.color(for: .darkText)
        
        return btn
    } ()
    
    func setUpView() {
        self.backgroundColor = UIColor.color(for: .lightBackground)
        self.addSubview(self.optionsBtn)
        self.height(to: Constants.BUTTON_SIZE)
        self.left(self.optionsBtn, fromLeft: true, paddingType: .none, withSafety: false)
        self.centerY(self.optionsBtn)
        self.optionsBtn.onClick(sender: self, selector: #selector(self.optionSelected))
    }
    
    @objc func optionSelected() {
        self.delegate?.optionSelected(data: self.moreOptionsData)
    }
}
