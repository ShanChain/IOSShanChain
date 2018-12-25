//
//  HotCommunityCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/18.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class HotCommunityCell: UITableViewCell {

    
    @IBOutlet weak var coverIcon: UIImageView!
    
    
    @IBOutlet weak var mapIcon: UIImageView!
    
    
    @IBOutlet weak var nameLb: UILabel!
    
    
    @IBOutlet weak var peopleNumberLb: UILabel!
    
    @IBOutlet weak var accessLb: UILabel!
    
    
    @IBOutlet weak var joinBtn: UIButton!
    
    weak var delegate: HotCommunityCellProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func joinAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.joinChatRoomFor(index: sender.tag)
        }
        
    }
    
}
