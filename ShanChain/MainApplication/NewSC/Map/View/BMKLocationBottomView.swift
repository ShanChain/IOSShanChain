//
//  BMKLocationBottomView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class BMKLocationBottomView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        var flag = false
        for view in self.subviews{
            if (view is UIButton) && view.tag == 6666{
                if (view.frame.contains(point)){
                    flag = true
                }
            }
        }
        return flag
    }

}
