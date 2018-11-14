//
//  TaskListBackView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskListBackView: UIView {

    
    @IBOutlet weak var timeLabel0: UILabel!
    
    @IBOutlet weak var timeLabel1: UILabel!
    
    @IBOutlet weak var timeLabel2: UILabel!
    
    @IBOutlet weak var timeLabel3: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var centerBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leftBtnWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var rightBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    var contentView:UIView!
    
    
    var listModel:TaskListModel?
    convenience init(listModel:TaskListModel,frame:CGRect) {
        self.init(frame: frame)
        self.listModel = listModel
        
        self.leftBtn.setTitle(listModel.backViewLeftBtnTuple.title, for: .normal)
        self.leftBtn.isHidden = !listModel.backViewLeftBtnTuple.isShow
        self.leftBtn.borderColor = listModel.backViewLeftBtnTuple.color
        self.leftBtn.setTitleColor(listModel.backViewLeftBtnTuple.color, for: .normal)
        self.leftBtnWidth.constant = CGFloat(listModel.backViewLeftBtnTuple.width)
        self.leftBtn.isUserInteractionEnabled = listModel.backViewLeftBtnTuple.isClick
        
        
        
        self.centerBtn.setTitle(listModel.backViewCenterBtnTuple.title, for: .normal)
        self.centerBtn.isHidden = !listModel.backViewCenterBtnTuple.isShow
        self.centerBtn.borderColor = listModel.backViewCenterBtnTuple.color
        self.centerBtn.setTitleColor(listModel.backViewCenterBtnTuple.color, for: .normal)
        self.centerBtnWidth.constant = CGFloat(listModel.backViewCenterBtnTuple.width)
        self.centerBtn.isUserInteractionEnabled = listModel.backViewCenterBtnTuple.isClick
        
        self.rightBtn.setTitle(listModel.backViewRightBtnTuple.title, for: .normal)
        self.rightBtn.isHidden = !listModel.backViewRightBtnTuple.isShow
        self.rightBtn.borderColor = listModel.backViewRightBtnTuple.color
        self.rightBtn.setTitleColor(listModel.backViewRightBtnTuple.color, for: .normal)
        self.rightBtnWidth.constant = CGFloat(listModel.backViewRightBtnTuple.width)
        self.rightBtn.isUserInteractionEnabled = listModel.backViewRightBtnTuple.isClick
        
        self.timeLabel0.text = "发布时间 \(listModel.createTime ?? "")"
        if let receiveTime = listModel.ReceiveTime{
            self.timeLabel1.text = "领取时间 \(receiveTime)"
        }else{
            self.timeLabel1.text = ""
        }
        
        if let expiryTime = listModel.expiryTime{
            self.timeLabel2.text = "完成时间 \(expiryTime)"
        }else{
            self.timeLabel2.text = ""
        }
        
        if let verifyTime = listModel.verifyTime{
            self.timeLabel3.text = "完成时间 \(verifyTime)"
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: 200)
        }else{
            self.timeLabel3.text = ""
        }
        
      
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        self.frame = frame
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
