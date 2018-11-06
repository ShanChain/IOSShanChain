//
//  DefConst.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/30.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation


@_exported import SnapKit

let SCREEN_HEIGHT = Int(UIScreen.main.bounds.size.height)
let SCREEN_WIDTH = Int(UIScreen.main.bounds.size.width)
let kApplicationStatusBarHeight = Int(UIApplication.shared.statusBarFrame.size.height)
let kNavBlueColor = RGB(115, 207, 242)
let SC_ThemeMainColor = _ThemeMainColor()

func IS_IPHONE_X() ->Bool{
    if UIScreen.main.bounds.height == 812 {
        return true
    }
    return false
}

func Font(_ size:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}
func RGB(_ r:Int , _ g:Int , _ b:Int) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b)
}

func _ThemeMainColor() ->UIColor {
    return UIColor.init(valueStr: "4FD1F6")
}

