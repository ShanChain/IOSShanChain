//
//  NSObject+extension.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/29.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation

typealias TapClosure = () -> Void

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    
    /**
     根据字符串的的长度来计算UITextView的高度
     
     - parameter textView:   UITextView
     - parameter fixedWidth:      UITextView宽度
     - returns:              返回UITextView的高度
     */
    internal class func heightForTextView(textView: UITextView, fixedWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let constraint = textView.sizeThatFits(size)
        return constraint.height
    }

}

extension UIButton{
    @IBInspectable var isSizeToFit: Bool {
        get {
            return self.titleLabel?.numberOfLines == 0 ? true:false
        }
        set {
            if newValue == true {
                self.sizeToFit()
                self.titleLabel?.numberOfLines = 0
            }
            
        }
    }
    
}

extension UILabel{
    
    @IBInspectable var isSizeToFit: Bool {
        get {
            return self.numberOfLines == 0 ? true:false
        }
        set {
            if newValue == true {
               self.sizeToFit()
               self.numberOfLines = 0
            }
            
        }
    }
    
    func needLines(withWidth width: CGFloat) -> Int {
        
        guard let text = self.text else { return 1 }
        
        //创建一个labe
        let label = UILabel()
        //font和当前label保持一致
        label.font = font
        var sum: Int = 0
        //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
        let splitText = text.components(separatedBy: "\n")
       
        for sText: String in splitText {
            label.text = sText
            //获取这段文字一行需要的size
            let textSize = label.systemLayoutSizeFitting(CGSize.zero)
            //size.width/所需要的width 向上取整就是这段文字占的行数
            var lines = ceilf(Float(textSize.width / width))
            //当是0的时候，说明这是换行，需要按一行算。
            lines = lines == 0 ? 1 : lines
            sum += Int(lines)
        }
        return sum
   }
}
extension String{
    // 高度自适应
    func heightForAdaptive(Font font:UIFont , _ width:CGFloat ) -> CGFloat {
        let attr = NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.font:font
            ])
        let mattrSize = attr.boundingRect(with:  CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        return mattrSize.height
    }

 
}

extension UIColor{
    convenience init(valueStr:String) {
        let scanner:Scanner = Scanner(string:valueStr)
        var valueRGB:UInt32 = 0
        if scanner.scanHexInt32(&valueRGB) == false {
            self.init(red: 0,green: 0,blue: 0,alpha: 0)
        }else{
            self.init(
                red:CGFloat((valueRGB & 0xFF0000)>>16)/255.0,
                green:CGFloat((valueRGB & 0x00FF00)>>8)/255.0,
                blue:CGFloat(valueRGB & 0x0000FF)/255.0,
                alpha:CGFloat(1.0)
            )
        }
    }
}

// MARK: - 时间转换
extension Date {
    
    static func getDate(dateStr: String, format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    func getComponent(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
    func getString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
}

