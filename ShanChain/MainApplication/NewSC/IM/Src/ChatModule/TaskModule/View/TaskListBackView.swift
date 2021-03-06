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
    
    var _listEntity:TaskListModel?
    var listModel:TaskListModel{
        set{
            _listEntity = newValue
            if _listEntity != nil {
                self.leftBtn.setTitle(_listEntity!.backViewLeftBtnTuple.title, for: .normal)
                self.leftBtn.isHidden = !_listEntity!.backViewLeftBtnTuple.isShow
                self.leftBtn.borderColor = _listEntity!.backViewLeftBtnTuple.color
                self.leftBtn.setTitleColor(_listEntity!.backViewLeftBtnTuple.color, for: .normal)
                self.leftBtnWidth.constant = CGFloat(_listEntity!.backViewLeftBtnTuple.width)
                self.leftBtn.isUserInteractionEnabled = _listEntity!.backViewLeftBtnTuple.isClick
                
                
                
                self.centerBtn.setTitle(_listEntity!.backViewCenterBtnTuple.title, for: .normal)
                self.centerBtn.isHidden = !_listEntity!.backViewCenterBtnTuple.isShow
                self.centerBtn.borderColor = _listEntity!.backViewCenterBtnTuple.color
                self.centerBtn.setTitleColor(_listEntity!.backViewCenterBtnTuple.color, for: .normal)
                self.centerBtnWidth.constant = CGFloat(_listEntity!.backViewCenterBtnTuple.width)
                self.centerBtn.isUserInteractionEnabled = _listEntity!.backViewCenterBtnTuple.isClick
                
                self.rightBtn.setTitle(_listEntity!.backViewRightBtnTuple.title, for: .normal)
                self.rightBtn.isHidden = !_listEntity!.backViewRightBtnTuple.isShow
                self.rightBtn.borderColor = _listEntity!.backViewRightBtnTuple.color
                self.rightBtn.setTitleColor(_listEntity!.backViewRightBtnTuple.color, for: .normal)
                self.rightBtnWidth.constant = CGFloat(_listEntity!.backViewRightBtnTuple.width)
                self.rightBtn.isUserInteractionEnabled = _listEntity!.backViewRightBtnTuple.isClick
                
                let postTimeStr = NSLocalizedString("sc_PostTime", comment: "字符串")
                let acceptedTimeStr = NSLocalizedString("sc_AcceptedTime", comment: "字符串")
                let finishTimeStr = NSLocalizedString("sc_FinishTime", comment: "字符串")
                let comfirmTimeStr = NSLocalizedString("sc_ComfirmTime", comment: "字符串")
                self.timeLabel0.text = "\(postTimeStr) \(NSDate.chatingTime(_listEntity!.createTime) ?? "")"
                if let receiveTime = _listEntity!.receiveTime{
                    self.timeLabel1.isHidden = false
                    self.timeLabel1.text = "\(acceptedTimeStr) \(NSDate.chatingTime(receiveTime)!)"
                }else{
                    self.timeLabel1.isHidden = true
                }
                
                if let expiryTime = _listEntity!.completeTime{
                    if _listEntity?.isHideCompleteTime == true{
                           self.timeLabel2.isHidden = true
                    }else{
                        self.timeLabel2.isHidden = false
                    }
                    self.timeLabel2.text = "\(finishTimeStr) \(NSDate.chatingTime(expiryTime)!)"
                }else{
                    self.timeLabel2.isHidden = true
                }
                
                if let verifyTime = _listEntity!.verifyTime{
                    self.timeLabel3.isHidden = false
                    self.timeLabel3.text = "\(comfirmTimeStr) \(NSDate.chatingTime(verifyTime)!)"
                }else{
                    self.timeLabel3.isHidden = true
                }
                
            }
            
            
        }
        
        get{
            return _listEntity!
        }
    }
    weak var delegate:TaskListCellProtocol?
    convenience init(listModel:TaskListModel,frame:CGRect) {
        self.init(frame: frame)
        self.listModel = listModel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.snp.makeConstraints { (mark) in
             mark.edges.equalTo(self)
        }
     
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func centerBtnAction(_ sender: UIButton) {
        guard delegate != nil else {
            return
        }
        
        if self.listModel.backViewRightBtnTuple.title == "催他完成" {
            delegate?.urgeComplete(listModel: listModel, view: self)
        }
    }
    
    @IBAction func rightBtnAction(_ sender: UIButton) {
        guard delegate != nil else {
            return
        }
        if self.listModel.backViewRightBtnTuple.title == NSLocalizedString("sc_Accomplished", comment: "字符串") {
            delegate?.receiveCompleted(listModel: listModel, view: self)
        }
        
        if self.listModel.backViewRightBtnTuple.title == NSLocalizedString("sc_comfirm", comment: "字符串") {
            delegate?.publishConfirmComplete(listModel: listModel, view: self)
        }
    }
    
    @IBAction func leftBtnAction(_ sender: UIButton){
        
        guard delegate != nil else {
            return
        }
        if self.listModel.backViewLeftBtnTuple.title == NSLocalizedString("sc_Canceled", comment: "字符串") {
            delegate?.receiveCancel(listModel: listModel, view: self)
        }
        
        if self.listModel.backViewLeftBtnTuple.title == NSLocalizedString("sc_undone", comment: "字符串") {
            delegate?.publishConfirmUndone(listModel: listModel, view: self)        }
        
    }
}
