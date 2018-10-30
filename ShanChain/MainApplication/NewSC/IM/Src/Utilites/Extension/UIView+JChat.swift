//
//  UIView+JChat.swift
//  JChat
//
//  Created by deng on 2017/3/22.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

extension UIView {

    var x: CGFloat {
        return frame.origin.x
    }
    
    var y: CGFloat {
        return frame.origin.y
    }
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var size: CGSize {
        return frame.size
    }
    
    var origin: CGPoint {
        return frame.origin
    }
    
    var centerX: CGFloat {
        return (frame.origin.x + frame.size.width) / 2
    }
    
    var centerY: CGFloat {
        return (frame.origin.y + frame.size.height) / 2
    }
    
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
}
