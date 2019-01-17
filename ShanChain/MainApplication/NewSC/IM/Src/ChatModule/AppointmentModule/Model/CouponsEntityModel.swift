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
    var getTime:Double = NSDate.init().timeIntervalSince1970 * 1000
    var useTime:Double = NSDate.init().timeIntervalSince1970 * 1000
    var unusedNum:String?
    var mortgageHash:String?
    var mortgageSeat:String?
    var getStatus:Int?
    
    var couponsStatus:CouponsStatus?{
        get{
            return CouponsStatus.init(rawValue: Int(tokenStatus!)!)
        }
    }
    // 卡劵列表状态判断显示title
    var listStatusTitle:String{
        get{
            if getStatus == 20 {
                return "查看"
            }else if getStatus == 21{
                return "已领取"
            }
            return "领取"
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
    
    var remainAmountTitle:String{
        return "剩余\(remainAmount!)张"
    }
    
    var getTimeStr:String{
        
        var myUseTime:Double = NSDate.init().timeIntervalSince1970 * 1000
        if tokenStatus == "10" {
            myUseTime = getTime
        }else if tokenStatus == "11"{
            myUseTime = useTime
        }else{
            myUseTime = deadline
        }
        let mcDate:MCDate = MCDate.init(interval: ((myUseTime) / 1000))
        let dateStr = mcDate.formattedDate(withFormat: "YYYY-MM-dd HH:mm")
        return dateStr!
    }
    
     required init() {}
}
