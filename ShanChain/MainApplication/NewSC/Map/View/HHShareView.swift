//
//  HHShareView.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/12/5.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

enum JSHAREPlatform:Int{
  case JSHAREPlatformWechatSession = 1
  case JSHAREPlatformWechatTimeLine
  case JSHAREPlatformWechatFavourite
    
  case JSHAREPlatformQQ
  case JSHAREPlatformQzone
    
  case JSHAREPlatformSinaWeibo
  case JSHAREPlatformSinaWeiboContact
    
  case JSHAREPlatformFacebook
  case JSHAREPlatformFacebookMessenger
    
    
  case JSHAREPlatformTwitter
  case JSHAREPlatformJChatPro
}


enum JSHAREMediaType:Int{
    case JSHAREText = 1
    case JSHAREImage
    case JSHARELink
    
    case JSHAREAudio
    case JSHAREVideo
    
    case JSHAREApp
    case JSHAREFile
    
    case JSHAREEmoticon
    case JSHARGraphic
    case JSHAREUndefined
}

class HHShareView: UIView {

    
    @IBOutlet var contentView: UIView!
    convenience init(uid:String,frame:CGRect) {
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        contentView = loadViewFromNib()
        addSubview(contentView)
        
        for (_,v) in subviews.enumerated(){
            if let btn = v as? UIButton{
                 btn.setEnlargeEdgeWithTop(10, right: 10, bottom: 20, left: 10)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func closeContentViewAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func shareWeChatAction(_ sender: UIButton) {
     
        let shareEntity = ShareContentModel.init()
        shareEntity.text = "欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能！";
        PublicShareService.share(shareEntity, platform: JSHAREPlatform.JSHAREPlatformWechatSession.rawValue, mediaType: JSHAREMediaType.JSHAREText.rawValue) { (state, error) in
            
        }
     
        
    }
    
    @IBAction func shareCircleFriendsAction(_ sender: UIButton) {
        let shareEntity = ShareContentModel.init()
        shareEntity.text = "欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能！";
        PublicShareService.share(shareEntity, platform: JSHAREPlatform.JSHAREPlatformWechatFavourite.rawValue, mediaType: JSHAREMediaType.JSHAREText.rawValue) { (state, error) in
            
        }
    }
    
    
    @IBAction func shareQQAction(_ sender: UIButton) {
        let shareEntity = ShareContentModel.init()
        shareEntity.text = "欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能！";
        PublicShareService.share(shareEntity, platform: JSHAREPlatform.JSHAREPlatformQQ.rawValue, mediaType: JSHAREMediaType.JSHAREText.rawValue) { (state, error) in
            
        }
    }
    
    
    @IBAction func shareSinaWeiboAction(_ sender: UIButton) {
        let shareEntity = ShareContentModel.init()
        shareEntity.text = "欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能！";
        PublicShareService.share(shareEntity, platform: JSHAREPlatform.JSHAREPlatformSinaWeibo.rawValue, mediaType: JSHAREMediaType.JSHAREText.rawValue) { (state, error) in
            
        }
    
    }
    
}
