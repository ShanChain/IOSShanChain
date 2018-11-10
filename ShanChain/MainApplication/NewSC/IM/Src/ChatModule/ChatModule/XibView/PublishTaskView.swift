//
//  PublishTaskView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/29.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

typealias PublishClosure = (_ text:String, _ reward:String , _ time:String, _ timestamp:String, _ isPut:Bool) ->Void //定义闭包类型

@IBDesignable
class PublishTaskView: UIView {

 
    @IBOutlet weak var taskDesTextFid: UITextField!
    
    @IBOutlet weak var publishBtn: UIButton!
    
   
    @IBOutlet weak var rewardTextFid: UITextField!
    @IBOutlet  var contentView: UIView!
    
    @IBOutlet weak var selectTimeTextFid: UITextField!
    
    var pbCallClosure:PublishClosure?
    let kDuration = 0.5
    
    private let makeView:UIView
    private var timestamp = Date().timeStamp
    
    
    override init(frame: CGRect) {
        makeView = UIView()
        super.init(frame: frame)
        self.frame = frame;
        makeView.frame = frame
        contentView = loadViewFromNib()
        publishBtn.addTarget(self, action: #selector(_publishPressed), for: .touchUpInside)
        
        //添加蒙版
       
        makeView.backgroundColor = .black
        makeView.alpha = 0.2
        addSubview(makeView)
        addSubview(contentView)
        show()
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapSelectTime))
        selectTimeTextFid.addGestureRecognizer(tap)
        
        
    }
    
    func _tapSelectTime(){
        let datePicker = YLDatePicker(currentDate: nil, minLimitDate: Date(), maxLimitDate: nil, datePickerType: .YMDHm) { [weak self] (date) in
            self?.selectTimeTextFid.text = date.getString(format: "yyyy-MM-dd HH:mm")
            self?.endEditing(true)
            self?.timestamp = String(Int(date.timeIntervalSince1970))
        }
        datePicker.show()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        makeView = UIView()
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        self.frame = frame;
       // self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
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
           self.makeView.removeFromSuperview()
        }
 
        
    }
    
    func _verification() -> Bool {
        if (self.taskDesTextFid.text?.isEmpty)!{
            HHTool.showError("请描述任务内容")
            return false
        }
        if (self.rewardTextFid.text?.isEmpty)!{
            HHTool.showError("请输入赏金")
            return false
        }
        
        if (self.selectTimeTextFid.text?.isEmpty)!{
            HHTool.showError("请选择时间")
            return false
        }
        
        return true
    }
    @IBAction func _close(_ sender: UIButton) {
        self.pbCallClosure!(self.taskDesTextFid.text!,(self.rewardTextFid.text)!,(self.selectTimeTextFid.text)!,timestamp,false)
    }
    func _publishPressed(){
        if _verification(){
        self.pbCallClosure!(self.taskDesTextFid.text!,(self.rewardTextFid.text)!,(self.selectTimeTextFid.text)!,timestamp,true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.endEditing(true)
         self.taskDesTextFid.resignFirstResponder()
    }
    
    
}
