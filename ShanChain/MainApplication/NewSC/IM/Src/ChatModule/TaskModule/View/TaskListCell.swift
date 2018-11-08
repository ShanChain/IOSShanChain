//
//  TaskListCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var issueLabel: UILabel!
    
    
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var completeBtn: UIButton!
    
    
    @IBOutlet weak var locactionLabel: UILabel!
    

    
    @IBOutlet weak var issueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       icon._setCornerRadiusCircle()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
