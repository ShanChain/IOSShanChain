//
//  RoomTopView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/26.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class RoomTopView: UIView {

    @IBOutlet weak var rewardLb: UILabel!
    
    @IBOutlet weak var conditionLb: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var contentView:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
