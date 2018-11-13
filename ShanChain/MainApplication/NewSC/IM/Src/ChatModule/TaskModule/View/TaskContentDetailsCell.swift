//
//  TaskContentDetailsCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

typealias LikeClosure = (_ idx:Int) ->Void


class TaskContentDetailsCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var nameLb: UILabel!
    
    
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var timeLb: UILabel!
    
    
    @IBOutlet weak var likeBtn: UIButton!
    
    var likeBlock:LikeClosure?
    
    @IBAction func likeAction(_ sender: UIButton) {
        self.likeBlock!(sender.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
