//
//  HHPublishTaskContentView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/31.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class HHPublishTaskContentView: UIView , JCMessageContentViewType{
   
    let contentLabelWidth:Int = SCREEN_WIDTH - 120 - 40
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    func apply(_ message: JCMessageType) {
        guard let content = message.content as? HHPublishTaskContent else {
            return
        }
        _message = message
        _delegate = content.delegate
        _reward = content.reward
        _taskContent = content.taskContent
        _completeTime = content.completeTime
        _taskId = content.taskId
        
        let sc_Reward = NSLocalizedString("sc_Reward", comment: "字符串")
        rewardLabel.attributedText = NSString.setAttrFirst("\(sc_Reward) ", color: SC_EmphasisColor, font: Font(13), secendString: content.reward ?? "", color: SC_ThemeMainColor, font: Font(16), threeString: " ￥", color: SC_EmphasisColor, font: Font(13))
        contentLabel.text = _taskContent
        completeTimeLabel.text = NSDate.chatingTime(_completeTime)
        
       let lineNumber = contentLabel.needLines(withWidth: CGFloat(self.contentLabelWidth))
        contentLabel.textAlignment = lineNumber > 1 ? .left : .center
        
        //自适应 更新frame
        if let  taskContent = _taskContent {
            contentLabel.frame = CGRect(x: 20, y: 50, width: self.contentLabelWidth, height: Int((taskContent.heightForAdaptive(Font: Font(14), CGFloat(self.contentLabelWidth))) + 10))
            completeTimeLabel.frame = CGRect(x: 20, y: Int(self.contentLabel.y + self.contentLabel.height + 20), width: self.contentLabelWidth, height: 25)
            receiveBtn.frame = CGRect(origin: CGPoint(x: Int(self.width/2.0) - 50, y:Int(self.completeTimeLabel.y + self.completeTimeLabel.height + 20)), size: CGSize(width: 100, height: 40))
            // 添加底部视图
//            addSubview(line)
//            addSubview(bottomView)
        }
        
    }
    private func _commonInit() {
       backgroundColor = .white
       addSubview(rewardLabel)
       addSubview(contentLabel)
       addSubview(completeTimeLabel)
       addSubview(receiveBtn)
        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapAction))
        addGestureRecognizer(tap)
        
    }
    
    
    private weak var _delegate: JCMessageDelegate?
    private var _taskContent: String?
    private var _reward: String?
    private var _completeTime: String?
    private var _taskId:String?
    private var _message: JCMessageType!
    private var _user: JMSGUser?
    
    private lazy var rewardLabel:UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 20, y: 20, width: self.contentLabelWidth, height: 25)
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = .black
        return lb
    }()
    
    private lazy var contentLabel:UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 20, y: 50, width: self.contentLabelWidth, height: 40)
        lb.numberOfLines = 0
        lb.font = Font(14)
        lb.textColor = RGB(16, 16, 16)
        return lb
    }()
    
    private lazy var completeTimeLabel:UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = Font(12)
        lb.textColor = RGB(16, 16, 16)
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var receiveBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("查看任务", for: .normal)
        btn.setTitleColor(SC_ThemeMainColor, for: .normal)
        btn.layer.cornerRadius = 20
        btn.borderColor = SC_ThemeMainColor
        btn.borderWidth = 1.0
        btn.titleLabel?.font = Font(13)
        btn.isUserInteractionEnabled = false
        btn.addTarget(self, action: #selector(_receiveTask), for: .touchUpInside)
        return btn
    }()
    
//    private lazy var line:UIView = {
//        let view = UIView()
//        view.backgroundColor = RGB(246, 249, 250)
//        view.frame = CGRect(x: 0, y:Int(self.height) - 44, width: Int(self.width), height: 4)
//        return view
//
//    }()
    
//    private lazy var bottomView:UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.frame = CGRect(x: 0, y:Int(self.height) - 40, width: Int(self.width), height: 40)
//
//        let btn1:UIButton = UIButton(type: .custom)
//        btn1.frame =  CGRect(x: 0, y: 0, width: Int(self.width)/2, height: 40)
//        btn1 .setTitle("150", for: .normal)
//        btn1 .setTitleColor(.black, for: .normal)
//        btn1.titleLabel?.font = Font(12)
//        btn1.setImage(UIImage.loadImage("评论"), for: .normal)
//        btn1.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
//        btn1.addTarget(self, action: #selector(_comment), for: .touchUpInside)
//        view.addSubview(btn1)
//
//        let btn2:UIButton = UIButton(type: .custom)
//        btn2.frame =  CGRect(x: Int(self.width)/2, y: 0, width: Int(self.width)/2, height: 40)
//        btn2 .setTitle("300", for: .normal)
//        btn2 .setTitleColor(.black, for: .normal)
//        btn2.titleLabel?.font = Font(12)
//        btn2.setImage(UIImage.loadImage("未喜欢"), for: .normal)
//        btn2.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
//        btn2.addTarget(self, action: #selector(_like), for: .touchUpInside)
//        view.addSubview(btn2)
//
//
//        let line = UIView()
//        line.backgroundColor = .black
//        line.frame = CGRect(x: Int(self.width)/2, y:0, width:1, height: Int(btn1.height))
//        line.alpha = 0.1
//        view.addSubview(line)
//        return view
//    }()
    
    @objc func _receiveTask(){
        // 查看任务
        _delegate?.message?(message: _message, receiveTask: "111")
    }
    
    @objc func _tapAction(){
        _delegate?.clickTaskMessage!(message: _message, tuple: [CUSTOM_CONTENT:_taskContent as AnyObject,CUSTOM_REWARD:_reward as AnyObject,CUSTOM_COMPLETETIME:_completeTime as AnyObject,CUSTOM_TASKID:_taskId as AnyObject])
    }
    
    
}
