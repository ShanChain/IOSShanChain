//
//  SmsVerifycodeModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/29.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class SmsVerifycodeModel: HandyJSON {
    
    var mobile:String?
    var salt:String?
    var smsVerifyCode:String?
    var timestamp:Int64?
    
    // 获取重置密码参数
    func _getSetPasswordParameter(_ password:String) -> Dictionary<String,Any> {
        let pwdMD5 = SCMD5Tool.md5(forUpper32Bate: password)
        let time:Int64 = Int64(Date().timeIntervalSince1970)
        let typeAppend = "USER_TYPE_MOBILE\(time)"
        let encryptAccount = SCAES.encryptShanChain(withPaddingString: typeAppend, withContent: mobile)
        let encryptPassword = SCAES.encryptShanChain(withPaddingString: "\(typeAppend)\(mobile!)", withContent: pwdMD5)
        let sign = SCMD5Tool.md5(forUpper32Bate: "\(smsVerifyCode!)\(salt!)\(timestamp!)")
        return ["userType":"USER_TYPE_MOBILE","Timestamp":"\(time)","encryptAccount":encryptAccount ?? "","encryptPassword":encryptPassword ?? "","sign":sign ?? ""]
    }
    
    // 获取修改手机号参数
    func _changePhoneNumberParameter(_ phone:String) -> Dictionary<String,Any> {
        
        let sign = SCMD5Tool.md5(forUpper32Bate: "\(smsVerifyCode!)\(salt!)\(timestamp!)")
        return ["newPhone":phone,"sign":sign ?? ""]
    }
    
    required init() {}
}
