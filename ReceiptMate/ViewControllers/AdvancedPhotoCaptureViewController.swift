//
//  AdvancedPhotoCaptureViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/11/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class AdvancedPhotoCaptureViewController: LUIViewController {
    
    var delegate: LUIImagePickerDelegate?
    
    private var changesMade: Bool = false
    private var image: UIImage? {
        didSet {
            self.contentView.image = image
        }
    }
    private var picker: LUIImagePicker?
    
    private lazy var dotOverlayView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.color(for: .shadow)
        return view
    } ()
    
    private lazy var contentView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    } ()
    
    private lazy var addImageBtn: LUIButton = {
        let btn = LUIButton(style: .filled, affirmation: false, negation: false, raised: true, paddingType: .regular, fontSize: .regular, textFontStyle: .regular)
        btn.text = "Upload image"
        btn.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        btn.onClick(sender: self, selector: #selector(self.addImage))
        return btn
    } ()
    
    func setUpViews() {
        self.title = "Advanced photo capture"
        self.view.backgroundColor = UIColor.color(for: .darkBackground)
        
        self.addView(self.contentView)
        self.view.top(self.contentView, fromTop: true, paddingType: .large, withSafety: true)
        self.view.left(self.contentView, fromLeft: true, paddingType: .none, withSafety: true)
        self.view.right(self.contentView, fromLeft: false, paddingType: .none, withSafety: false)
        
        self.addView(self.dotOverlayView)
        self.fill(self.dotOverlayView)
        
        self.addView(self.addImageBtn)
        self.centerX(self.addImageBtn)
        self.view.bottom(self.addImageBtn, fromTop: false, paddingType: .regular, withSafety: true)
        
        self.addImageBtn.top(self.contentView, fromTop: false, paddingType: .regular, withSafety: false)
        
        self.picker = LUIImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addImageBtn.text = self.image == nil ? "Upload image" : "Change image"
    }
    
    @objc func addImage(_ sender: LUIButton) {
        self.picker?.present(from: sender)
    }

}

extension AdvancedPhotoCaptureViewController: LUIImagePickerDelegate {
    
    func didSelect(image: UIImage?, identifier: String?) {
        if let image = image {
            self.image = image
            self.dotOverlayView.isHidden = false
        }
    }
    
}
