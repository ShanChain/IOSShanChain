//
//  MyCouponsModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/18.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

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
    
    required init() {}
    
}
