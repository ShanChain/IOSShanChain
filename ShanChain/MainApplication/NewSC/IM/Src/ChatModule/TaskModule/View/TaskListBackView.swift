//
//  TaskListBackView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskListBackView: UIView {

    var contentView:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
