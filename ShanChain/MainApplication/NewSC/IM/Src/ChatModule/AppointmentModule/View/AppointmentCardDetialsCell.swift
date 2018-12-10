//
//  AppointmentCardDetialsCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/10.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


private let H_cell = "AppointmentCardDetialsCell"

class AppointmentCardDetialsCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var nikeNameLb: UILabel!
    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var statusLb: UILabel!
    
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
