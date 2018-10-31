//
//  NSObject+extension.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/29.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation

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

