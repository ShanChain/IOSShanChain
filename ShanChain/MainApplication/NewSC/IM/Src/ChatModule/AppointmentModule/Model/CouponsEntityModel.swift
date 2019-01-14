//
//  CouponsEntityModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/18.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class CouponsEntityModel: HandyJSON {

    var isNewRecord:Bool = false
    var couponsId:String?
    var userId:String?
    var subuserId:String?
    var name:String?
    var amount:String?
    var sendOutNum:String?
    var remainAmount:String?
    var price:String?
    var tokenStatus:String?
    var createTime:Double = NSDate.init().timeIntervalSince1970 * 1000
    var deadline:Double = NSDate.init().timeIntervalSince1970 * 1000
    var photoUrl:String?
    var tokenSymbol:String?
    var detail:String?
    var hash:String?
    var record:String?
    var roomid:String?
    var usedNum:String?
    var getTime:String?
    var unusedNum:String?
    var mortgageHash:String?
    var mortgageSeat:String?
    
    var couponsStatus:CouponsStatus?{
        get{
            return CouponsStatus.init(rawValue: Int(tokenStatus!)!)
        }
    }
    
    // 主卡劵是否已失效
    var isMainInvalid:Bool?{
        get{
            if tokenStatus == "0" {
                return  false
            }
            return  true
        }
    }
    required init() {}
    
    //  领取方状态
    var recipientStatusTitle:String{
        get{
            if tokenStatus == "10" {
                return  "已领取"
            }else if tokenStatus == "11"{
                return  "已核销"
            }
            return "已失效"
        }
    }
}
