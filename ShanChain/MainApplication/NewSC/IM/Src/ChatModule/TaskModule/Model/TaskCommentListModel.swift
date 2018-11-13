//
//  TaskCommentListModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/12.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskCommentListModel: HandyJSON{
    
    var last:String?
    var totalElements:String?
    var totalPages:String?
    var number:String?
    var size:String?
    var first:String?
    var numberOfElements:String?
    var content:[TaskCommentListModel_content]?
    var sort:[TaskCommentListModel_sort]?
    required init() {}
}


class TaskCommentListModel_content: HandyJSON{
    
    var commentId:String?
    var taskId:String?
    var characterId:String?
    var userId:String?
    var parentId:String?
    var content:String?
    var supportCount:String?
    var createTime:String?
    var mySupport:Bool = false
    var supportSet:String?
    
    
    required init() {}
}


class TaskCommentListModel_sort: HandyJSON{
    
    var direction:String?
    var property:String?
    var ignoreCase:String?
    var nullHandling:String?
    var ascending:String?
    var descending:String?
    
    required init() {}
}
