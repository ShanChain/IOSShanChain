//
//  TaskRecieveSuccessModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/13.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskRecieveSuccessModel: HandyJSON {

    var ReceiveTime:String?
    var PublishTime:String?
    var HxUserName:String?
    var ExpiryTime:String?
    var TaskReceive:TaskRecieveSuccessModel_TaskReceive?
    
    required init() {}
}

class TaskRecieveSuccessModel_TaskReceive: HandyJSON {
    
    var taskId:String?
    var characterId:String?
    var roomId:String?
    var userId:String?
    var createTime:String?
    var completeTime:String?
    var urge:String?
    var cancelTime:String?
    var id:String?
    
    required init() {}
}


