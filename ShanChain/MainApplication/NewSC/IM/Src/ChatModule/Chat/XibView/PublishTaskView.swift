//
//  PublishTaskView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/29.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

typealias PublishClosure = (_ text:String) ->Void //定义闭包类型

@IBDesignable
class PublishTaskView: UIView {

 
    @IBOutlet weak var taskDesTextFid: UITextField!
    
    @IBOutlet weak var publishBtn: UIButton!
    
   
    @IBOutlet var contentView: UIView!
    
    var pbCallClosure:PublishClosure?
    let kDuration = 0.5
    
    
    
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//             layer.borderColor = borderColor?.cgColor
//        }
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame;
        contentView = loadViewFromNib()
       // self.translatesAutoresizingMaskIntoConstraints = false
        publishBtn.addTarget(self, action: #selector(_publishPressed), for: .touchUpInside)
        addSubview(contentView)
        show()
    }
    
    func setPbCallClosure(closure:@escaping PublishClosure){
        self.pbCallClosure = closure
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        layer.add(animation, forKey: "scale-layer")
       delay(0.45) {
           self.removeFromSuperview()
        }
 
        
    }
    
    func _publishPressed(){
        self.pbCallClosure!(self.taskDesTextFid.text!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.endEditing(true)
         self.taskDesTextFid.resignFirstResponder()
    }
    
    
}
