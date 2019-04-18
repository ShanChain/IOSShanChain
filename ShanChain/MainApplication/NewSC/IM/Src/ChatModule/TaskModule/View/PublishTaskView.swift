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

 

    @IBOutlet weak var taskDesTextFid: UITextView!
    
    @IBOutlet weak var publishBtn: UIButton!
    
   
    @IBOutlet weak var rewardTextFid: UITextField!
    @IBOutlet  var contentView: UIView!
    
    @IBOutlet weak var selectTimeTextFid: UITextField!
    
    @IBOutlet weak var needHelpLb: UILabel!
    
    @IBOutlet weak var timeLimitLb: UILabel!
    
    
    @IBOutlet weak var desLb: UILabel!
    
    @IBOutlet weak var rewardLb: UILabel!
    
    @IBOutlet weak var exchangeRateLabel: UILabel!
    var pbCallClosure:PublishClosure?
    let kDuration = 0.5
    
    private let makeView:UIView
    private var timestamp = Date().timeStamp
    private var taskModel:TaskAddModel?
    
    
    convenience init(taskModel:TaskAddModel?, frame: CGRect) {
        self.init(frame: frame)
        self.taskModel = taskModel
      
    }
    
    override init(frame: CGRect ) {
        makeView = UIView()
        super.init(frame: frame)
        self.frame = frame;
        makeView.frame = frame
        contentView = loadViewFromNib()
        contentView.frame = frame
        publishBtn.addTarget(self, action: #selector(_publishPressed), for: .touchUpInside)
        taskDesTextFid.placeholder = NSLocalizedString("sc_Enter_", comment: "字符串")
        rewardTextFid.placeholder = NSLocalizedString("sc_rewardFid", comment: "字符串")
        selectTimeTextFid.placeholder = NSLocalizedString("sc_choose", comment: "字符串")
        timeLimitLb.text = NSLocalizedString("sc_TimeLimit", comment: "字符串")
        needHelpLb.text = NSLocalizedString("sc_PostTask", comment: "字符串")
        desLb.text = NSLocalizedString("sc_Describe", comment: "字符串")
        rewardLb.text = NSLocalizedString("sc_Reward", comment: "字符串")
        publishBtn.setTitle(NSLocalizedString("sc_post", comment: "字符串"), for: .normal)
        //添加蒙版
       
        makeView.backgroundColor = .black
        makeView.alpha = 0.2
        addSubview(makeView)
        addSubview(contentView)
        show()
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(_tapSelectTime))
        selectTimeTextFid.addGestureRecognizer(tap)
        taskDesTextFid.delegate = self
        rewardTextFid.delegate = self;
        exchangeRateLabel.text = "1 SEAT = \(SCCacheTool.shareInstance().currencyModel.rate!)￥"
        publishBtn.addRoundedCorners(.bottomLeft, withRadii:CGSize(width: 10, height: 10))
        publishBtn.addRoundedCorners(.bottomRight, withRadii:CGSize(width: 10, height: 10))
    }
    
    @objc func _tapSelectTime(){
        
        let datePicker = YLDatePicker(currentDate: Date(), minLimitDate:MCDate.init(date: Date()).byAddHours(1).date, maxLimitDate: MCDate.init(date: Date()).byAddYears(20).date, datePickerType: .YMDHm) { [weak self] (date) in
            self?.selectTimeTextFid.text = date.getString(format: "YYYY-MM-dd HH:mm")
            self?.endEditing(true)
            self?.timestamp = String(Int(date.timeIntervalSince1970*1000))
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
        animation.fillMode = CAMediaTimingFillMode.forwards
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
            HHTool.showError("请输入答谢金")
            return false
        }
        
        if (self.selectTimeTextFid.text?.isEmpty)!{
            HHTool.showError("请选择时间")
            return false
        }
        
        return true
    }
    
   private lazy var _taskReward:String = {
    if self.rewardTextFid.text?.length == 0{
        return ""
    }
    let index = self.rewardTextFid.text?.index((self.rewardTextFid.text?.startIndex)!, offsetBy: 1)
       let result = self.rewardTextFid.text?.substring(from: index!)
       return result!
    }()
    
    @IBAction func _close(_ sender: UIButton) {
        self.pbCallClosure!(self.taskDesTextFid.text!,(_taskReward),(self.selectTimeTextFid.text)!,timestamp,false)
    }
    @objc func _publishPressed(){
        if _verification(){
        self.pbCallClosure!(self.taskDesTextFid.text!,(_taskReward),(self.selectTimeTextFid.text)!,timestamp,true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.endEditing(true)
         self.taskDesTextFid.resignFirstResponder()
    }
    
    
}

extension PublishTaskView:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text:String = "\(textField.text ?? "")\(string)"
        let lmrRange = text.range(of: "￥")
        if lmrRange == nil && string != ""{
            text = "￥" + text
        }
        // 正在删除
        if string == "" {
            let index = text.index(text.startIndex, offsetBy: text.length - 1)
            let subText = text.substring(to: index)
            if subText == "￥"{
                text = ""
            }else{
                text = subText
            }
            
        }
        textField.text = text
        if text.length > 5 {
            let index = text.index(text.startIndex, offsetBy: 5)
            let subText = text.substring(to: index)
            text = subText
            textField.text = subText
            return false
        }
        if textField == rewardTextFid && (text.length) > 0{
            let index = text.index(text.startIndex, offsetBy: 1)
            let result = text.substring(from: index)
            calculatingExchangeRate(rmb:result)
        }else{
            exchangeRateLabel.text = "1 SEAT = \(SCCacheTool.shareInstance().currencyModel.rate!)￥"
        }
        return false
    }
    
    func calculatingExchangeRate(rmb:String){
        if Float(rmb) == nil {
            HHTool.showError(NSLocalizedString("sc_IncorrectFormat", comment: "字符串"))
            return
        }
        let rete:Float = Float(SCCacheTool.shareInstance().currencyModel.rate!)
        let seat:Float = Float(rmb)!/rete
         exchangeRateLabel.text = " = \(formatFloat(seat) ?? "")SEAT"
    }
    
    func formatFloat(_ f: Float) -> String? {
        if fmodf(f, 1) == 0 {
            //如果有一位小数点
            return String(format: "%.0f", f)
        } else if fmodf(f * 10, 1) == 0 {
            //如果有两位小数点
            return String(format: "%.1f", f)
        } else if fmodf(f * 100, 1) == 0 {
            return String(format: "%.2f", f)
        } else{
            return String(format: "%.3f", f)
        }
    }
    
}

extension PublishTaskView:UITextViewDelegate{
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        let str = "\(textView.text)\(text)"
//        
//        if str.count > 50 {
//            //textView.text = (str as NSString?)?.substring(to: 50)
//            textView.text = str.prefix(50)
//            
//            HHTool.showError("不能超过50个字")
//            return false
//        }
//        return true
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.markedTextRange == nil {
            let text = textView.text!
            if text.count > 50 {
                let range = text.startIndex ..< text.index(text.startIndex, offsetBy: 50)

                let subText = text.substring(with: range)
                textView.text = subText
                HHTool.showError("任务描述不能超过50个字")
            }
        }
    }
    
}




