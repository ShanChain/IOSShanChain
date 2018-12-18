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
    var createTime:String?
    var deadline:Double?
    var photoUrl:String?
    var tokenSymbol:String?
    var detail:String?
    var hash:String?
    var record:String?
    var roomid:String?
    var usedNum:String?
    var unusedNum:String?
    var mortgageHash:String?
    var mortgageSeat:String?
    
    required init() {}
}
