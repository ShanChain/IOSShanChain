//
//  TaskListCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/7.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell{

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var issueLabel: UILabel!
    
    
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var completeBtn: UIButton!
    
    
    @IBOutlet weak var locactionLabel: UILabel!
    

    @IBOutlet weak var tagIcon: UIImageView!
    
    @IBOutlet weak var issueDateLabel: UILabel!
    
    
    @IBOutlet weak var centerStatusBtn: UIButton!
    var revealedCardIsFlipped: Bool = false //是否翻转到反面
    private var revealedCardFlipView: UIView?  // 翻转反面视图
    
    weak var delegate:TaskListCellProtocol?
    
    var _listModel:TaskListModel?
    var listModel:TaskListModel?{
        
        set{
            _listModel = newValue
            self.rewardLabel.text = "\(_listModel?.bounty ?? "") SEAT"
            self.contentLabel.text = _listModel?.intro
            self.icon._sd_setImage(withURLString: _listModel?.headImg, placeholderImage: SC_defaultImage)
            self.issueLabel.text = "\(_listModel?.name ?? "")发布的:"
            self.issueDateLabel.text = "\(NSDate.chatingTime(_listModel?.expiryTime) ?? "") 前"
            self.locactionLabel.text = "来自:\(_listModel?.roomName ?? "")"
            self.cornerRadius = 10.0
            if (_listModel?.isReceived)! {
                self.centerStatusBtn.setTitle(NSLocalizedString("sc_helped", comment: "字符串"), for: .normal)
                self.centerStatusBtn.setTitleColor(UIColor.gray, for: .normal)
                self.centerStatusBtn.borderColor = UIColor.gray
            }else{
                self.centerStatusBtn.setTitle("查看", for: .normal)
                self.centerStatusBtn.setTitleColor(SC_ThemeMainColor, for: .normal)
                self.centerStatusBtn.borderColor = SC_ThemeMainColor
            }
            
        }
        
        get{
            
            return _listModel
        }
        
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
       icon._setCornerRadiusCircle()
        let iconTap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(_tapGestureAvatar))
        icon.addGestureRecognizer(iconTap)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
   open func flipRevealedCard(toView: UIView, completion: (() -> Void)? = nil) {
     if(self.revealedCardIsFlipped == true) {
        return
     }
        toView.removeFromSuperview()
        toView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.revealedCardFlipView = toView
        toView.isHidden = true
        self.addSubview(toView)
        layer.masksToBounds = true
        self.revealedCardIsFlipped = true
        UIApplication.shared.keyWindow?.endEditing(true)
        let originalShouldRasterize = self.layer.shouldRasterize
        self.layer.shouldRasterize = false
        
        UIView.transition(with: self, duration: 0.5, options:[.transitionFlipFromRight], animations: { () -> Void in
            self.contentView.isHidden = true
            toView.isHidden = false
        }, completion: { (Bool) -> Void in
            self.layer.shouldRasterize = originalShouldRasterize
            completion?()
        })
    }
    
    open func flipRevealedCardBack(completion: (() -> Void)? = nil) {
        if(self.revealedCardIsFlipped == false) {
            completion?()
            return
        }
        if let flipView = self.revealedCardFlipView {
            let originalShouldRasterize = self.layer.shouldRasterize
            UIApplication.shared.keyWindow?.endEditing(true)
            self.layer.shouldRasterize = false
            UIView.transition(with: self, duration: 0.5, options:[.transitionFlipFromLeft], animations: { () -> Void in
                flipView.isHidden = true
                self.contentView.isHidden = false
            }, completion: { (Bool) -> Void in
                flipView.removeFromSuperview()
                self.layer.shouldRasterize = originalShouldRasterize
                self.revealedCardFlipView = nil
                self.revealedCardIsFlipped = false
                completion?()
            })
        }
    }
 
    
    @IBAction func centerStatusAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.callBack(listModel: _listModel!)
        }
    }
    
    @objc func _tapGestureAvatar(){
        if let delegate = delegate {
            delegate._clickAvatar(listModel: _listModel!)
        }
    }
    
}
