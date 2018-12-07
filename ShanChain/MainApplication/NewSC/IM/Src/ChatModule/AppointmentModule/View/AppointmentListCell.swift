//
//  AppointmentListCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class AppointmentListCell: UITableViewCell {

   
    @IBOutlet weak var nameLb: UILabel!
    
    
    @IBOutlet weak var iconImg: UIImageView!
    
    
    @IBOutlet weak var deadlineLb: UILabel!
    
    @IBOutlet weak var nikeNameLb: UILabel!
    
    
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var priceLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
