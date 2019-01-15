//
//  CreateCouponExampleView.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/15.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class CreateCouponExampleView: UIView {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect ) {
    
        super.init(frame: frame)
        self.frame = frame;
        contentView = loadViewFromNib()
        contentView.frame = frame
        contentView.alphaComponentMake()
        img.preventImageViewExtrudeDeformation()
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
}
