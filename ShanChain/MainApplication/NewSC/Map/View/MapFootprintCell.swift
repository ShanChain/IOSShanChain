//
//  MapFootprintCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class MapFootprintCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var numberPeopleLb: UILabel!
    
    @IBOutlet weak var timeLb: UILabel!
    
    
    @IBOutlet weak var enterBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        enterBtn.cornerRadius = enterBtn.height/2.0
        enterBtn.layer.borderColor = SC_ThemeMainColor.cgColor
        enterBtn.layer.borderWidth = 1
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
    
    func stringCount(_ string:String) -> Int{
         return string.length
    }
    
    @IBAction func enterAction(_ sender: Any){
        
    }
    
}
