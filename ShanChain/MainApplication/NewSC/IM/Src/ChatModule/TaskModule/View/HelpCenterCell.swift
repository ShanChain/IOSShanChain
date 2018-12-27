//
//  HelpCenterCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/27.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class HelpCenterCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var nameLb: UILabel!
    
    
    @IBOutlet weak var timeLb: UILabel!
    
    
    @IBOutlet weak var rewardLb: UILabel!
    
    
    @IBOutlet weak var contentLb: UILabel!
    
    
    @IBOutlet weak var dealLineLb: UILabel!
    
    
    @IBOutlet weak var statusBtn: UIButton!
    
    
    
    weak var delegate:HelpCenterCellProtocol?
    
    var _listModel:TaskListModel?
    var listModel:TaskListModel?{
        
        set{
            _listModel = newValue
            self.rewardLb.text = "￥ \(_listModel?.bounty ?? "")"
            self.contentLb.text = _listModel?.intro
            self.icon._sd_setImage(withURLString: _listModel?.headImg, placeholderImage: SC_defaultImage)
            self.nameLb.text = _listModel?.name ?? ""
            self.dealLineLb.text = "完成时限: \(NSDate.chatingTime(_listModel?.expiryTime) ?? "")"
            self.timeLb.text = NSDate.chatingTime(_listModel?.createTime) ?? ""
            if (_listModel?.isReceived)! {
               self.statusBtn.setTitle(NSLocalizedString("sc_helped", comment: "字符串"), for: .normal)
               self.statusBtn.setTitleColor(.black, for: .normal)
            self.statusBtn.setBackgroundImage(UIImage.loadImage("sc_com_icon_hot_gray"), for: .normal)
            }else{
                self.statusBtn.setTitle(NSLocalizedString("sc_giveHand", comment: "字符串"), for: .normal)
                self.statusBtn.setTitleColor(.white, for: .normal)
                self.statusBtn.setBackgroundImage(UIImage.loadImage("Rectangle11"), for: .normal)
            }
            
        }
        
        get{
            
            return _listModel
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = SC_ThemeBackgroundViewColor
        self.contentView.backgroundColor = SC_ThemeBackgroundViewColor
        icon._setCornerRadiusCircle()
        let iconTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(_tapGestureAvatar))
        icon.addGestureRecognizer(iconTap)
    }
    
    // 点击头像
    func _tapGestureAvatar(){
        if let delegate = delegate {
            delegate._clickAvatar(listModel: _listModel!)
        }
    }
    
    // 帮他一下
    @IBAction func helpHereAction(_ sender: UIButton) {
        if _listModel?.isReceived == true{
            return
        }
        
        if let delegate = delegate {
            delegate._helpHereWith(listModel: _listModel!)
        }
    }
    
    
}
