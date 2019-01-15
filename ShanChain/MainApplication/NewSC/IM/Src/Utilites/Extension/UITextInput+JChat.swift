//
//  UITextInput+JChat.swift
//  JChat
//
//  Created by 邓永豪 on 2017/10/18.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

protocol TextProtocol {
    func limitNonMarkedTextSize(_ maxSize: Int)
}

extension UITextView: TextProtocol {
    func limitNonMarkedTextSize(_ maxSize: Int) {
        if self.markedTextRange != nil {
            return
        }
        let text = self.text!
        if text.characters.count > maxSize {
            let range = Range<String.Index>(text.startIndex ..< text.index(text.startIndex, offsetBy: maxSize))

            let subText = text.substring(with: range)
            self.text = subText
        }
    }
}

private var adjust = "adjust"

extension UITextField {
    func setTintAjust(_ tintAjust: CGFloat) {
        objc_setAssociatedObject(self, &adjust, tintAjust, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        let leftView = UILabel(frame: CGRect(x: tintAjust, y: 0, width: tintAjust, height: frame.size.height))
        leftView.backgroundColor = UIColor.clear
        self.leftView = leftView
        leftViewMode = .always
    }
    
    func tintAjust() -> CGFloat {
        let value = objc_getAssociatedObject(self, &adjust)
        return value as! CGFloat
    }
}
