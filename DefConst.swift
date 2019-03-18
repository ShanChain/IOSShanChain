//
//  DefConst.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/30.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation


@_exported import SnapKit
@_exported import HandyJSON
@_exported import RxSwift
@_exported import IQKeyboardManager

let FirstReleaseTask = "FirstReleaseTask"
let FirstCreateCoupons = "FirstCreateCoupons"
//let PUBLISH_TIPNAME  = "用户不得利用马甲服务发布、传播或者转载如下内容"
//let PUBLISH_TITLE  = "\n1、反对宪法所确定的基本原则的；危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n2、 含有法律、行政法规禁止的其他内容的信息；\n3、 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n4、煽动民族仇恨、民族歧视，破坏民族团结的；\n5、侮辱、滥用英烈形象，否定英烈事迹，美化粉饰侵略战争行为的；\n6、 散布谣言，扰乱社会秩序，破坏社会稳定的；\n7、破坏国家宗教政策，宣扬邪教和封建迷信的；\n马甲有权对用户使用马甲的情况下进行审查和监督，如用户在使用马甲时违反任何上述规定，马甲或其授权的人有权要求用户改正或直接采取一切必要的措施（包括但不限于改正或删除用户发布的信息内容、暂停或终止用户使用马甲的权利）以减轻用户不当行为造成的影响。"
let PUBLISH_TIPNAME  = "\n用户不得利用马甲服务发布、传播或者转载如下内容\n\n1、反对宪法所确定的基本原则的；危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n2、 含有法律、行政法规禁止的其他内容的信息；\n3、 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n4、煽动民族仇恨、民族歧视，破坏民族团结的；\n5、侮辱、滥用英烈形象，否定英烈事迹，美化粉饰侵略战争行为的；\n6、 散布谣言，扰乱社会秩序，破坏社会稳定的；\n7、破坏国家宗教政策，宣扬邪教和封建迷信的；\n马甲有权对用户使用马甲的情况下进行审查和监督，如用户在使用马甲时违反任何上述规定，马甲或其授权的人有权要求用户改正或直接采取一切必要的措施（包括但不限于改正或删除用户发布的信息内容、暂停或终止用户使用马甲的权利）以减轻用户不当行为造成的影响。"
let PUBLISH_TITLE  = ""

let SCREEN_HEIGHT = Int(UIScreen.main.bounds.size.height)
let SCREEN_WIDTH = Int(UIScreen.main.bounds.size.width)
let kApplicationStatusBarHeight = Int(UIApplication.shared.statusBarFrame.size.height)
let kNavBlueColor = SC_ThemeMainColor
let SC_ThemeMainColor = _ThemeMainColor()
let SC_CantClickColor = UIColor.init(valueStr: "BBBBBB") // 按钮不能点击颜色
let SC_ThemeBackgroundViewColor = RGB(245, 245, 245)
let SC_EmphasisColor = UIColor.black // 主要字体颜色
let SC_defaultImage = UIImage.loadImage("sc_com_icon_DefaultAvatar")
let SC_phoneNumber:String =   UserDefaults.standard.object(forKey: "K_USERNAME") as! String //当前用户手机号
let SC_SavePhotoFileName = NSLocalizedString("sc_MJ", comment: "字符串")

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
    return UIColor.init(valueStr: "AC81E9")
}

