//
//  TaskAddModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/11.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskAddModel: NSObject {
   
    var task:TaskAddModel_task = TaskAddModel_task()
    var PublishTime:String = ""
    
    
}

class TaskAddModel_task: NSObject {
    
    var taskId:String = ""
    var verify:String = ""
    var bounty:String = ""
    var topping:String = ""
    var intro:String = ""
    var roomId:String = ""
    var statusHistory:String = ""
    var createTime:String = ""
    var expiryTime:String = ""
    var status:String = ""
    var receiveCount:String = ""
    var commentCount:String = ""
    var supportCount:String = ""
    var characterId:String = ""
    var verifyTime:String = ""
    var unfinishedTime:String = ""
    var currency:String = ""
    var releaseHash:String = ""
    var lastHash:String = ""
    var userId:String = ""
    
}