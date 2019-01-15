//
//  MyCouponsModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/18.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


enum CouponsStatus:Int{
    
    case create_Wait = 0 // 创建方创建成功  主卡劵
    case create_Complete  // 创建方已核销
    case create_Invalid // 创建方已失效
    
//    case receive_Un = 10    //领取方未领取
    case receive_Wait = 10      // 领取方待使用
    case receive_Complete   // 领取方已使用
    case receive_Transfer // 转让中
    case receive_Invalid // 领取方已失效
}


class MyCouponsModel: HandyJSON {

    var isNewRecord:Bool = false
    var tokenName:String?
    var name:String?
    
    var couponsId:String?
    var subCoupId:String?
    
    var deadline:Double?
    var photoUrl:String?
    var price:String?
    var tokenStatus:String?
    var tokenSymbol:String?
    var amount:Int = 0 // 总张数
    var sendOutNum:Int = 0 // 被领取的张数
    var remainAmount:Int = 0 // 剩余张数
    
    var sendOutNumTitle:String{
        if sendOutNum > 0 {
            return "被领取\(sendOutNum)张"
        }
        return "全部被领取"
    }
    
    var remainAmountTitle:String{
        return "剩余\(remainAmount)张"
    }
    
    var orderID:String?{
        get{
            if self.couponsId != nil && self.couponsId != "" {
                return self.couponsId
            }
            return self.subCoupId
        }
    }
    
    
    var nikeName:String?{
        get{
            if self.name != nil && self.name != "" {
                return self.name
            }
            return self.tokenName
        }
    }
    
    var statusTitle:String{
        
        get{
            if tokenStatus == "10" {
                return "待使用"
            }else if tokenStatus == "11"{
                return "已使用"
            }else if tokenStatus == "13"{
                return "已失效"
            }
            
            return "查看"
        }
    }
    
    var couponsStatus:CouponsStatus?{
        get{
            return CouponsStatus.init(rawValue: Int(tokenStatus!)!)
        }
    }
    required init() {}
    
}
