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
    @IBOutlet weak var contactBtn: UIButton!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    private let makeView:UIView
    let kDuration = 0.5
    var closure:RecieveClosure?
        
    override init(frame: CGRect) {
        makeView = UIView()
        super.init(frame: frame)
        spView = loadViewFromNib()
        
        contentLabel.text = "分类看见对方离开手机打开了附件是考虑到福建省了房间都是离开房间是龙卷风多凉快圣诞节疯狂老师福建省了肯德基逢狼时刻福建省了会计法看风景了深刻的纠纷类似的看法讲述了快递费讲述了快捷方式离开就分手快乐发生了纠纷空间裂缝是肯定就发了多少空间是快捷方式来看大嫁风尚开房记录是福建省了房价来说"
        let  height = (contentLabel.text?.heightForAdaptive(Font: Font(14), CGFloat(SCREEN_WIDTH - 100)))! + 330.0
        contentViewHeight.constant = height
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
        closure!("111")
        dismiss()
    }
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if view == makeView{
                if(!contentView.frame.contains(point)){
                    closure!("111")
                    dismiss()
                    
                }
            }
            
        }
        return true
    }

}


