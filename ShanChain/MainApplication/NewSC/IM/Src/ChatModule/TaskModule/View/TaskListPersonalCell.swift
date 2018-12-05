//
//  TaskListPersonalCell.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskListPersonalCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var issueLabel: UILabel!
    
    
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var locactionLabel: UILabel!
    
    
    @IBOutlet weak var tagIcon: UIImageView!
    
    @IBOutlet weak var issueDateLabel: UILabel!
    
    
    @IBOutlet weak var statusBtn: UIButton!
    
    
    @IBOutlet weak var statusBtnWidth: NSLayoutConstraint!
    var revealedCardIsFlipped: Bool = false //是否翻转到反面
    private var revealedCardFlipView: UIView?  // 翻转反面视图
    
    weak var delegate:TaskListCellProtocol?
    
    var _listModel:TaskListModel?
    var listModel:TaskListModel?{
        
        set{
            _listModel = newValue
            self.rewardLabel.text = "￥ \(_listModel?.price ?? "")"
            self.contentLabel.text = _listModel?.intro
          
            
            if (_listModel?.isMyBublish)! {
                self.issueLabel.text = "\(_listModel?.name ?? "")领取的:"
            }else{
                self.issueLabel.text = "\(_listModel?.name ?? "")发布的:"
            }
            
            
            self.issueDateLabel.text = "\(NSDate.chatingTime(_listModel?.expiryTime) ?? "") 前"
            self.locactionLabel.text = "来自:\(_listModel?.roomName ?? "")"
            self.cornerRadius = 10.0
            self.statusBtn.setTitle(_listModel?.personalStatusBtnTuple.title, for: .normal)
            self.statusBtnWidth.constant = CGFloat((_listModel?.personalStatusBtnTuple.width)!)
            if _listModel?.personalStatusBtnTuple.isClick  == true {
                self.statusBtn.borderColor = SC_ThemeMainColor
                self.statusBtn.setTitleColor(SC_ThemeMainColor, for: .normal)
                self.statusBtn.isUserInteractionEnabled = false
            }else{
                self.statusBtn.borderColor = .gray
                self.statusBtn.setTitleColor(.gray, for: .normal)
                self.statusBtn.isUserInteractionEnabled = true
            }
            
            self.icon._sd_setImage(withURLString: _listModel?.headImg, placeholderImage: SC_defaultImage)
            self.tagIcon.isHidden = !(_listModel?.isHiddenIcon)!
            self.issueLabel.isHidden = (_listModel?.isHiddenIcon)!
            self.icon.isHidden = (_listModel?.isHiddenIcon)!
            self.statusBtn.isHidden = (_listModel?.isHiddenIcon)!
            
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
    
    
    @IBAction func clickBtnAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.callBack(listModel: _listModel!)
        }
    }
    
    func _tapGestureAvatar(){
        if let delegate = delegate {
            delegate._clickAvatar(listModel: _listModel!)
        }
    }
}
