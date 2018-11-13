//
//  AddTaskCommentModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/12.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class AddTaskCommentModel: HandyJSON {
  
    var characterId:String?
    var commentId:String?
    var content:String?
    var createTime:String?
    var mySupport:Bool?
    var parentId:String?
    var supportCount:String?
    var taskId:String?
    var userId:String?
    
    required init() {}
}
