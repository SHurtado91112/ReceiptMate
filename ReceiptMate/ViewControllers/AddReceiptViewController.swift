//
//  AddReceiptViewController.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 9/2/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI
import WSTagsField

extension Notification.Name {
    static let RMReceiptAdded = Notification.Name(rawValue: "RM_RECEIPT_ADDED_NOTIFICATION")
}

class AddReceiptViewController: LUIViewController {
    
    
    // MARK: - Public properties
    
    var storeSuggestions: [String] = [] {
        didSet {
            self.storeField.field.filterStrings(self.storeSuggestions)
        }
    }
    
    
    // MARK: - Private properties
    
    private let previewer = LUIPreviewManagerViewController()
    
    private lazy var contentView: LUIStackView = {
        let stackView = LUIStackView(padding: .regular)
        return stackView
    } ()
    
    private lazy var storeField: RMSearchField = {
        let field = RMSearchField()
        field.subtitle = "Store"
        field.placeholder = "Target"
        return field
    } ()
    
    private lazy var dateField: RMDateField = {
        let field = RMDateField(direction: .horizontal)
        field.subtitle = "Date"
        field.placeholder = "Jun 7, 2019"
        field.dateStyle = .medium
        field.timeStyle = .none
        return field
    } ()
    
    private lazy var tagField: WSTagsField = {
        let tv = WSTagsField()
        
        let paddingManager = LUIPaddingManager.shared
        tv.layoutMargins = paddingManager.paddingRect(for: .small)//UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tv.contentInset = paddingManager.paddingRect(for: .regular)
        tv.spaceBetweenLines = paddingManager.padding(for: .regular)
        tv.spaceBetweenTags = paddingManager.padding(for: .regular)
        tv.font = tv.font?.substituteFont.withSize(.regular)
        
        tv.backgroundColor = UIColor.color(for: .intermidiateBackground).withAlphaComponent(0.2)
        tv.tintColor = UIColor.color(for: .theme).withAlphaComponent(0.6)
        tv.textColor = UIColor.color(for: .lightText)
        tv.fieldTextColor = UIColor.color(for: .darkText)
        tv.selectedColor = UIColor.color(for: .theme)
        tv.selectedTextColor = UIColor.color(for: .lightText)
        tv.delimiter = ""
        tv.isDelimiterVisible = false
        tv.placeholderColor = UIColor.color(for: .intermidiateText)
        tv.placeholderAlwaysVisible = false
        tv.returnKeyType = UIReturnKeyType.next
        tv.acceptTagOption = .return
        tv.cornerRadius = Constants.ROUNDED_CORNER_CONSTANT
        tv.layer.cornerRadius = Constants.ROUNDED_CORNER_CONSTANT
        tv.height(to: 48.0, constraintOperator: .greaterThan)
        return tv
    } ()
    
    private lazy var detailSubtitleLabel: LUILabel = {
        let label = LUILabel(color: .darkText, fontSize: .large, fontStyle: .bold)
        label.text = "Receipt details"
        return label
    } ()
    
    private lazy var photoSubtitleLabel: LUILabel = {
        let label = LUILabel(color: .darkText, fontSize: .large, fontStyle: .bold)
        label.text = "Receipt photo"
        return label
    } ()

    private var receiptImage: UIImage? {
        didSet {
            self.receiptImageView.image = self.receiptImage
            self.receiptImageView.imageView?.contentMode = .scaleAspectFill
            let uploaded = self.receiptImage != nil
            self.receiptImageContainer.isHidden = !uploaded
            self.uploadBtn.text = !uploaded ? "Upload receipt photo" : "Change receipt photo"
            
            self.canSubmit()
        }
    }
    
    private var imagePicker: LUIImagePicker?

    private lazy var receiptImageView: LUIButton = {
        let btn = LUIButton(style: .none, affirmation: false, negation: false, raised: false, paddingType: .none, fontSize: .regular, textFontStyle: .regular)
        btn.backgroundColor = .clear
        
        btn.height(to: 80.0)
        btn.width(to: 60.0)
        
        btn.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        btn.clipsToBounds = true
        btn.onClick(sender: self, selector: #selector(self.previewImage))
        
        return btn
    } ()
    
    private lazy var receiptImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        let label = LUILabel(color: .darkText, fontSize: .regular, fontStyle: .regular)
        label.text = "Receipt photo uploaded"
        
        view.addSubview(self.receiptImageView)
        view.addSubview(label)
        
        view.top(self.receiptImageView, fromTop: true, paddingType: .none, withSafety: false, constraintOperator: .equal)
        view.bottom(self.receiptImageView, fromTop: false, paddingType: .none, withSafety: false, constraintOperator: .equal)
        
        view.top(label, fromTop: true, paddingType: .none, withSafety: false, constraintOperator: .equal)
        view.bottom(label, fromTop: false, paddingType: .none, withSafety: false, constraintOperator: .equal)
        
        view.left(self.receiptImageView, fromLeft: true, paddingType: .none, withSafety: false, constraintOperator: .equal)
        view.right(label, fromLeft: false, paddingType: .none, withSafety: false)
        
        self.receiptImageView.right(label, fromLeft: true, paddingType: .regular, withSafety: false, constraintOperator: .equal)
        
        view.isHidden = true
        
        return view
    } ()
    
    private lazy var uploadBtn: LUIButton = {
        let btn = LUIButton(style: .filled, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .regular, textFontStyle: .regular)
        btn.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        btn.backgroundColor = UIColor.color(for: .theme).withAlphaComponent(0.8)
        
        btn.text = "Upload receipt photo"
        btn.onClick(sender: self, selector: #selector(self.requestUpload))
        
        return btn
    } ()
    
    private lazy var advancedCaptureBtn: LUIButton = {
        let btn = LUIButton(style: .outlined, affirmation: false, negation: false, raised: false, paddingType: .regular, fontSize: .small, textFontStyle: .italics)
        btn.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        
        btn.text = "Advanced photo capture"
        btn.onClick(sender: self, selector: #selector(self.requestAdvancedCapture))
        btn.isHidden = true
        
        return btn
    } ()
    
    private lazy var submitBtn: LUIButton = {
        let btn = LUIButton(style: .filled, affirmation: true, negation: false, raised: false, paddingType: .regular, fontSize: .large, textFontStyle: .bold)
        btn.roundCorners(to: Constants.ROUNDED_CORNER_CONSTANT)
        
        btn.text = "Submit receipt"
        btn.onClick(sender: self, selector: #selector(self.submitReceipt))
        
        btn.isHidden = true
        
        return btn
    } ()
    
    func setUpViews() {
        self.title = "Add New Receipt"
        
        self.addView(self.contentView)
        
        self.view.top(self.contentView, fromTop: true, paddingType: .none, withSafety: true)
        self.view.bottom(self.contentView, fromTop: false, paddingType: .none, withSafety: false)
        self.view.left(self.contentView, fromLeft: true, paddingType: .none, withSafety: true)
        self.view.right(self.contentView, fromLeft: false, paddingType: .none, withSafety: false)
        
        self.contentView.addPadding(.regular)
        self.contentView.addArrangedSubview(contentView: self.detailSubtitleLabel, fill: true)
        self.contentView.addArrangedSubview(contentView: self.storeField, fill: true)
        self.contentView.addArrangedSubview(contentView: self.dateField, fill: true)
        self.contentView.addArrangedSubview(contentView: self.tagField, fill: true)
        
        self.contentView.addPadding(.regular)
        self.contentView.addArrangedSubview(contentView: self.photoSubtitleLabel, fill: true)
        self.contentView.addArrangedSubview(contentView: self.receiptImageContainer, fill: true)
        self.contentView.addArrangedSubview(contentView: self.uploadBtn, fill:true)
        self.contentView.addArrangedSubview(contentView: self.advancedCaptureBtn, fill: true)
        self.contentView.addPadding(.regular)
        self.contentView.addArrangedSubview(contentView: self.submitBtn, fill: true)
        self.contentView.addPadding(.large)
        
        let fields: [UIResponder] = [
            self.storeField.field,
            self.dateField.field
        ]
        
        LUIKeyboardManager.shared.setTextFields(fields)
        
        self.imagePicker = LUIImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.registerEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.unregisterEvents()
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Private functions
    
    private func registerEvents() {
        // Registering for text field notification.
        let DidEndEditing = UITextField.textDidEndEditingNotification
        NotificationCenter.default.addObserver(self, selector: #selector(self.canSubmit), name: DidEndEditing, object: nil)
        
        self.advancedCaptureBtn.isHidden = !UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }
    
    private func unregisterEvents() {
       
        // Registering for text field notification.
        let DidEndEditing = UITextField.textDidEndEditingNotification
        NotificationCenter.default.removeObserver(self, name: DidEndEditing, object: nil)
        
    }
    
    // MARK: - Selectors
    
    var receipt: Receipt? {
        
        let receipt = Receipt(dict: [:])
        receipt.storeName = self.storeField.text
        receipt.date = self.dateField.date
        
        receipt.tags = []
        for tag in self.tagField.tags {
            receipt.tags.append(tag.text)
        }
        
        receipt.receiptImage = self.receiptImage
        
        return receipt
    }
    
    @objc private func canSubmit() {
        
        var canSubmit = false
        let tags = self.tagField.tags
        
        canSubmit = !(self.storeField.text?.isEmpty ?? true) &&
                    !(self.dateField.text?.isEmpty ?? true) &&
                    tags.count > 0 &&
                    self.receiptImage != nil
        
        self.submitBtn.isHidden = !canSubmit
    }
    
    @objc private func requestUpload(_ sender: LUIButton) {
        self.imagePicker?.present(from: sender)
    }
    
    @objc private func requestAdvancedCapture(_ sender: LUIButton) {
        
    }
    
    @objc private func previewImage(_ sender: UIImageView) {
        if let receiptImage = self.receiptImage {
            self.previewer.previewContent = [receiptImage]
            
            self.navigation?.present(self.previewer.dismissableModalViewController(), animated: true, completion: nil)
        }
    }
    
    @objc private func submitReceipt() {
        
        if let receipt = self.receipt {
            
            LUIActivityIndicatorView.shared.present(withStyle: .full, from: self)
            RMAPI.Database.createReceipt(receipt) { (success, errorString) in
                LUIActivityIndicatorView.shared.dismiss()
                
                if success {
                    
                    UIAlertController.presentAlertWithOptions(title: "Nice!", message: "We got your receipt uploaded. We'll take good care of it.", options: [
                        UIAlertAction(title: "Woohoo!", style: .default, handler: { (action) in
                            
                            self.dismiss(animated: true, completion: {
                                NotificationCenter.default.post(name: Notification.Name.RMReceiptAdded, object: nil)
                            })
                            
                        })
                    ], viewController: self)
                    
                } else {
                    
                    UIAlertController.presentAlert(title: "Uh oh...", message: errorString ?? "Something went wrong...", actionText: "/:", viewController: self)
                    
                }
                
            }
            
        }
        
    }
}

extension AddReceiptViewController: LUIImagePickerDelegate {
    
    func didSelect(image: UIImage?, identifier: String?) {
        self.receiptImage = image
    }
    
}
