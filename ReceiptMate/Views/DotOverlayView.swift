//
//  DotOverlayView.swift
//  ReceiptMate
//
//  Created by Steven Hurtado on 10/12/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit
import LazyUI

class DotOverlayView: LUIView {
    
    var topLeftCorner: CGPoint = .zero
    lazy var topLeftDot: LUIButton = {
        return self.getCommonDot()
    } ()
    
    var topRightCorner: CGPoint = .zero
    lazy var topRightDot: LUIButton = {
        return self.getCommonDot()
    } ()
    
    var bottomLeftCorner: CGPoint = .zero
    lazy var bottomLeftDot: LUIButton = {
        return self.getCommonDot()
    } ()
    
    var bottomRightCorner: CGPoint = .zero
    lazy var bottomRightDot: LUIButton = {
        return self.getCommonDot()
    } ()
    
    private func getCommonDot() -> LUIButton {
        let btn = LUIButton(style: .filled, affirmation: false, negation: false, raised: true, paddingType: .none, fontSize: .regular, textFontStyle: .regular)
        btn.circle(to: Constants.ICON_SIZE)
        LUIDraggable.addView(btn)
        return btn
    }
    
    func setUpView() {
        self.backgroundColor = UIColor.color(for: .shadow)
        
        self.addSubview(self.topLeftDot)
        self.addSubview(self.topRightDot)
        self.addSubview(self.bottomLeftDot)
        self.addSubview(self.bottomRightDot)
    }

}
