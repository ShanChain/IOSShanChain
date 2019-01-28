//
//  VersionUpdateModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/25.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class VersionUpdateModel: HandyJSON {
   
    var apkId:String?
    var url:String?
    var name:String?
    var source:String?
    var forceUpdate:Bool = false
    var version:String?
    var createTime:String?
    var latest:String?
    var mobile:String?
    var status:String?
    
    
    required init() {}
}
