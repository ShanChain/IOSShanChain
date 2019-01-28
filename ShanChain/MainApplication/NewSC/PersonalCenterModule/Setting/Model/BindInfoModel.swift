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
    
    
    func _isBind(_ row:Int) -> Bool{
        if row == 0 {
            return wechat
        }
        
        if row == 1 {
            return qq
        }
        
        if row == 2 {
            return facebook
        }
        
        return false
    }
    
    func _getBindParameter(_ row:Int,_ complete: @escaping (_ userInfo:Dictionary<String, Any>) -> ()){
        var otherAccount:String = ""
        if row == 0 {
            if wechat == false{
                JSHAREService.getSocialUserInfo(.wechatSession) { (userInfo, error) in
                    if let userInfo = userInfo{
                        otherAccount = userInfo.openid ?? userInfo.uid
                    complete(["otherAccount":otherAccount,"userType":"USER_TYPE_WEIXIN","userId":self.userId!])
                    }
                }
            }else{
                complete(["otherAccount":otherAccount,"userType":"USER_TYPE_WEIXIN","userId":self.userId!])
            }
        }
        if row == 1 {
            if qq == false{
                JSHAREService.getSocialUserInfo(.QQ) { (userInfo, error) in
                    if let userInfo = userInfo{
                        otherAccount = userInfo.openid ?? userInfo.uid
                    complete(["otherAccount":otherAccount,"userType":"USER_TYPE_QQ","userId":self.userId!])
                    }
                }
            }else{
                complete(["otherAccount":otherAccount,"userType":"USER_TYPE_QQ","userId":self.userId!])
            }
           
        }
        
        if row == 2 {
            if facebook == false{
                JSHAREService.getSocialUserInfo(.facebook) { (userInfo, error) in
                    if let userInfo = userInfo{
                        otherAccount = userInfo.openid ?? userInfo.uid
                    complete(["otherAccount":otherAccount,"userType":"USER_TYPE_FB","userId":self.userId!])
                    }
                }
            }else{
                complete(["otherAccount":otherAccount,"userType":"USER_TYPE_FB","userId":self.userId!])
            }
        }
        
    }
    
    required init() {}
}
