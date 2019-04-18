//
//  ChatPublicService.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/27.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

typealias callBack = (_ resultObject:Any? , _ error:NSError?) ->Void

class ChatPublicService: NSObject {
    // 添加好友关注
    @objc public static func jg_addFriendFeFocus(funsJmUserName:String){
        let  characterId = SCCacheTool.shareInstance().getCurrentCharacterId()
        SCNetwork.shareInstance().v1_post(withUrl: AddFocus_URL, params: ["funsJmUserName":funsJmUserName,"characterId":characterId], showLoading: false) { (baseModel, error) in
            
        }
    }
    
}
