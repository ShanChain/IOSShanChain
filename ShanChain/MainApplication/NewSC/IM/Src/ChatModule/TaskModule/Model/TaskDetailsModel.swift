//
//  TaskDetailsModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/13.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskDetailsModel: HandyJSON {
  
    var bounty:String?
    var commentCount:String?
    var expiryTime:String?
    var headImg:String?
    var intro:String?
    var name:String?
    var roomId:String?
    var status:String?
    var supportCount:String?
    var taskId:String?
    var publishTime:String?
    
    // 任务是否被领取
    func isReceive() -> Bool{
        if status == "5" {
            return false
        }
        return true
    }
    
    func receiveBtnTitle() -> String {
        if isReceive() {
           return "已被领取"
        }
        return "领取任务"
    }
    
    required init() {}
}
