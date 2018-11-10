//
//  TaskContentDetailsCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskContentDetailsCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var nameLb: UILabel!
    
    
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var timeLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
