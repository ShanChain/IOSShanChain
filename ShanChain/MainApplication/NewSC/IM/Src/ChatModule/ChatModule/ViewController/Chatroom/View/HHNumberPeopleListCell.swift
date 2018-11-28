//
//  HHNumberPeopleListCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/28.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


class HHNumberPeopleListCell: UITableViewCell {

    @IBOutlet weak var dialogueBtn: UIButton!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var nikeNameLb: UILabel!
    
    weak var delegate:HHNumberPeopleListCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func dialogueAction(_ sender: UIButton) {
       
    }
}
