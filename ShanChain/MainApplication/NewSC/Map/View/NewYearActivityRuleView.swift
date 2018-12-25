//
//  NewYearActivityRuleView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class NewYearActivityRuleView: UIView {

   
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet var contentView: UIView!
    
    @IBAction func confirmAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
    
    convenience init(ruleDes:String?, frame: CGRect) {
        self.init(frame: frame)
        textView.text = ruleDes ?? ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.alphaComponentMake()
        contentView = loadViewFromNib()
        addSubview(contentView)
        textView.isEditable = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
