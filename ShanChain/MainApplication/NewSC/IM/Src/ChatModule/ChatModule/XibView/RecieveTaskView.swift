//
//  RecieveTaskView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/31.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

typealias RecieveClosure = (_ conversationID:String) -> Void

class RecieveTaskView: UIView {

    @IBOutlet var spView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var completeTimeLabel: UILabel!
    
    @IBOutlet weak var acceptedLb: UILabel!
    
    @IBOutlet weak var contactBtn: UIButton!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    private let makeView:UIView
    let kDuration = 0.5
    var closure:RecieveClosure?
    var recieTaskModel:TaskRecieveSuccessModel?
    
    
    convenience init(recieTaskModel:TaskRecieveSuccessModel,frame:CGRect) {
        self.init(frame: frame)
        self.recieTaskModel = recieTaskModel
        contentLabel.text = self.recieTaskModel?.intro
        
        let sc_Reward = NSLocalizedString("sc_Reward", comment: "字符串")
        rewardLabel.text = "\(sc_Reward)\(self.recieTaskModel?.bounty ?? "") SEAT"
       let  sc_TimeLimit = NSLocalizedString("sc_TimeLimit", comment: "字符串")
        completeTimeLabel.text = "\(sc_TimeLimit):\(self.recieTaskModel?.TaskReceive?.completeTime ?? "")"
        let  height = (self.recieTaskModel?.intro?.heightForAdaptive(Font: Font(14), CGFloat(SCREEN_WIDTH - 100)))! + 330.0
        contentViewHeight.constant = height
        acceptedLb.text = NSLocalizedString("sc_accepted", comment: "字符串")
        contactBtn.setTitle(NSLocalizedString("sc_Contact", comment: "字符串"), for: .normal)
    }
    
    override init(frame: CGRect) {
        makeView = UIView()
        super.init(frame: frame)
        makeView.frame = frame
        spView = loadViewFromNib()
        
        //添加蒙版
        makeView.backgroundColor = .black
        makeView.alpha = 0.2
        addSubview(makeView)
        addSubview(spView)
        show()
        
        contactBtn.layer.borderWidth = 1
        contactBtn.layer.borderColor = RGB(115, 207, 242).cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.duration = kDuration
        animation.repeatCount = 1
        //        animation.autoreverses = true
        animation.fromValue = NSNumber.init(value: 0.01)
        animation.toValue = NSNumber.init(value: 1.0)
        layer.add(animation, forKey: "scale-layer")
    }
    
    func dismiss() {
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        animation.duration = kDuration
        animation.repeatCount = 1
        //        animation.autoreverses = true
        animation.fromValue = NSNumber.init(value: 1.0)
        animation.toValue = NSNumber.init(value: 0.01)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        layer.add(animation, forKey: "scale-layer")
        _ = delay(0.45) {
            self.removeFromSuperview()
            self.layer.removeAllAnimations()
            self.makeView.layer.removeAllAnimations()
            self.makeView.removeFromSuperview()
            CATransaction.commit()
        }
        
        
    }
    
    // 联系赏主
    @IBAction func contactPressed(_ sender: UIButton) {
        closure!((self.recieTaskModel?.HxUserName)!)
        dismiss()
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if view == makeView{
                if(!contentView.frame.contains(point)){
                    dismiss()
                    
                }
            }
            
        }
        return true
    }

}


