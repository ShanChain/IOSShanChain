//
//  PersonalCenterService.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/1/29.
//  Copyright © 2019年 ShanChain. All rights reserved.
//

import UIKit

class PersonalCenterService: NSObject {
    
    class func _checkingUpdate(_ isTip:Bool){
        // 检查更新
        SCNetwork.shareInstance().v1_post(withUrl: checkUpdate_URL, params: ["type":"ios"], showLoading: isTip) { (baseModel, error) in
            if let data = baseModel?.data as? Dictionary<String,Any>{
                let model = VersionUpdateModel.deserialize(from: data)
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
                
                if ((model?.version) != nil) && (NSString.compareVersion(version as! String, withServerVersion: model?.version) == true){
                    if model?.forceUpdate == true{
                        // 强制更新
                        _ = HHTool.getCurrentVC().sc_hrShowAlert(withTitle: model?.title, message: model?.intro, buttonsTitles: ["立即更新"], andHandler: { (_, _) in
                            UIApplication.shared.openURL(URL(string: (model?.url)!)!)
                        })
                        
                    }else{
                        // 选择更新
                        
                        _ = HHTool.getCurrentVC().sc_hrShowAlert(withTitle: model?.title, message: model?.intro, buttonsTitles: ["取消","立即更新"], andHandler: { (_, index) in
                            if index == 1{
                                UIApplication.shared.openURL(URL(string: (model?.url)!)!)
                            }
                        })
                        
                    }
                }else{
                    // 已经是最新版本
                   // HHTool.showTip("当前已是最新版本", duration: 1.0)
                }
            }else{
                if isTip == true{
                    // 已经是最新版本
                    HHTool.showTip("当前已是最新版本", duration: 1.0)
                }
            }
        }
    }
    
}
