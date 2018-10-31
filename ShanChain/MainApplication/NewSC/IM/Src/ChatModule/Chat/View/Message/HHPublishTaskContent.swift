//
//  HHPublishTaskContent.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/31.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class HHPublishTaskContent: NSObject,JCMessageContentType{
    var delegate: JCMessageDelegate?
    
   public override init() {
    let  text = "this is a test text"
    self.text = NSAttributedString(string: text)
        super.init()
    }
    
    public init(text: String) {
        self.text = NSAttributedString(string: text)
        super.init()
    }
    public init(attributedText: NSAttributedString) {
        self.text = attributedText
        super.init()
    }
    
    
    open var layoutMargins: UIEdgeInsets = .zero
    
    open class var viewType: JCMessageContentViewType.Type {
        return HHPublishTaskContentView.self
    }
    
    open var taskContent: String?
    open var reward:String?
    open var completeTime:String?
    
    open var text:NSAttributedString
    
    open func sizeThatFits(_ size: CGSize) -> CGSize {
        if let task = taskContent {
            text = NSAttributedString(string:task)
        }
        let mattr = NSMutableAttributedString(attributedString: text)
        mattr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, mattr.length))
        let mattrSize = mattr.boundingRect(with: CGSize(width: Double(SCREEN_WIDTH - 120), height: Double(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        self.text = mattr
        return .init(width: CGFloat(SCREEN_WIDTH - 120), height: mattrSize.height + 240)
    }
    
}
