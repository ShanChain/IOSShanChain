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
    case JSHARERedenvelope // 红包
    
    
    case JSHAREAudio
    case JSHAREVideo
    
    case JSHAREApp
    case JSHAREFile
    
    case JSHAREEmoticon
    case JSHARGraphic
    case JSHAREUndefined
}
typealias HHShareViewClosure = () -> Void

class HHShareView: UIView {

    
    @IBOutlet weak var showView: UIView!
    @IBOutlet var contentView: UIView!
    
    private  var shareImage:UIImage?
    
    @IBOutlet weak var scaleLb: UILabel!
    @IBOutlet weak var redenvelopeImageView: UIImageView!
    private  var shareType:JSHAREMediaType = .JSHAREText
    
    var closure:HHShareViewClosure?
    
    convenience init(uid:String,frame:CGRect,shareImage:UIImage?,type:Int){
        self.init(frame: frame)
        self.shareImage = shareImage;
        self.shareType = JSHAREMediaType.init(rawValue: type)!
        
        if self.shareType == .JSHAREImage{
            if let image = self.shareImage{
                let imageV = UIImageView.init(image: image)
                imageV.image = image
                contentView.addSubview(imageV)
                imageV.snp.makeConstraints { (make) in
                    make.centerY.centerX.equalTo(contentView)
                    make.width.equalTo(image.size.width)
                    make.height.equalTo(image.size.height)
                }
            }
        }
        if self.shareType == .JSHARERedenvelope{
            self.showView.isHidden = true
            self.redenvelopeImageView.isHidden = false
            self.scaleLb.isHidden = false
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeContentViewAction))
             self.redenvelopeImageView.addGestureRecognizer(tap)
        }else{
            self.showView.isHidden = false
            self.redenvelopeImageView.isHidden = true
        }
      
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.alphaComponentMake()
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
        closure?()
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
