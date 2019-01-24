//
//  BindInfoModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/24.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class BindInfoModel: HandyJSON {
    
    var qq:Bool = false
    var password:Bool = false
    var weibo:Bool = false
    var facebook:Bool = false
    var idcard:Bool = false
    var wechat:Bool = false
    var email:Bool = false
    
    var mobile:String?
    var userId:String?
    
    var pwTitle:String{
        if password == true {
            return "重置密码"
        }
        return "设置密码"
    }
    
    var qqBindTitle:String{
        if qq == true {
            return "已绑定"
        }
        return "未绑定"
    }
    
    var wxBindTitle:String{
        if wechat == true {
            return "已绑定"
        }
        return "未绑定"
    }
    
    var fbBindTitle:String{
        if facebook == true {
            return "已绑定"
        }
        return "未绑定"
    }
    
    var idCardTitle:String{
        if idcard == true {
            return "已认证"
        }
        return "未认证"
    }
    
    required init() {}
}
