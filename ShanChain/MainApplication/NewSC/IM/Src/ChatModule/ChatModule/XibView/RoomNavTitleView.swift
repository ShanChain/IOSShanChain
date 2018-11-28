//
//  RoomNavTitleView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/2.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


typealias NumberForPeopleClosure = () -> Void

class RoomNavTitleView: UIView {

    @IBOutlet weak var positionBtn: UIButton!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var numberForPeopleBtn: UIButton!
    
    var numberForPeopleClosure:NumberForPeopleClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var intrinsicContentSize:CGSize{
    
    return UILayoutFittingExpandedSize
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        positionBtn.isSelected = !positionBtn.isSelected
    }
    
    @IBAction func numberForPeopleAction(_ sender: UIButton) {
         numberForPeopleClosure!()
    }
    
    
}
