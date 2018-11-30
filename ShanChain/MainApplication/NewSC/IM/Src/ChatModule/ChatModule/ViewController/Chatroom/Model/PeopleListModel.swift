//
//  PeopleListModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/28.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class PeopleListModel: HandyJSON {

    var username:String?
    var flag:String?
    var room_ctime:String?
    var mtime:String?
    var ctime:String?
    var user:JMSGUser?
    var nickname:String?
    var iconImage:UIImage = UIImage.loadImage("com_icon_user_40")!
    required init() {}
    
    
    
}
