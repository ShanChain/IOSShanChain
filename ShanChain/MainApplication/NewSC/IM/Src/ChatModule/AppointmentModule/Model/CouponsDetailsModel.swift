//
//  CouponsDetailsModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/11.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class CouponsDetailsModel: HandyJSON {
    
    var isNewRecord:Bool = false
    var id:String?
    var subCoupId:String?
    var userId:String?
    var subuserId:String?
    var tokenName:String?
    var amount:String?
    var vendorUser:String?
    var vendorSubuser:String?
    var price:String?
    var tokenStatus:String?
    var roomid:String?
    var getTime:String?
    var photoUrl:String?
    var tokenSymbol:String?
    var detail:String?
    var getHash:String?
    var useHash:String?
    var nikeName:String?
    var remainAmount:String?
    var deadline:Double = NSDate.init().timeIntervalSince1970 * 1000
    
    
    var couponsStatus:CouponsStatus?{
        get{
            return CouponsStatus.init(rawValue: Int(tokenStatus!)!)
        }
    }
    
    var deadlineStr:String{
        let mcDate:MCDate = MCDate.init(interval: ((deadline) / 1000))
        let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd")
        return "有效期至:\(dateStr!)"
    }
    
    required init() {}
}
