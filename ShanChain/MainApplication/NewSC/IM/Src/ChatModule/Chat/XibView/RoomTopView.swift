//
//  RoomTopView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/26.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

typealias ExpandClosure = (_ isExpand:Bool) -> Void


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
    var isExpand:Bool = false
    var nomalFrame:CGRect
    var expandFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    var expandClosure:ExpandClosure?
    var recognizer:UISwipeGestureRecognizer?
    
    
    var contentView:UIView!
    override init(frame: CGRect) {
        nomalFrame = frame
        super.init(frame: frame)
        contentView = loadViewFromNib()
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        UIView.animate(withDuration: 0.5, animations: {
            self.frame = self.isExpand ? self.nomalFrame:self.expandFrame
        }) { (complete) in
            self.isExpand = !self.isExpand
            self.expandClosure!(self.isExpand)
        }
    }

}
