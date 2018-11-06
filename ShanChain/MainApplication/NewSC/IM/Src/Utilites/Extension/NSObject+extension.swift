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

}

extension UILabel{
    func needLines(withWidth width: CGFloat) -> Int {
        //创建一个labe
        let label = UILabel()
        //font和当前label保持一致
        label.font = font
        let text = self.text
        var sum: Int = 0
        //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
        let splitText = text?.components(separatedBy: "\n")
        for sText: String in splitText! {
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
            NSFontAttributeName:font
            ])
        let mattrSize = attr.boundingRect(with:  CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        return mattrSize.height
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
    
}

