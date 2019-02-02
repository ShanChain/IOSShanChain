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
    var shareModel:CommonShareModel?
    
    
    @IBOutlet weak var showViewTop: NSLayoutConstraint!
    @IBOutlet weak var scaleLbTop: NSLayoutConstraint!
    convenience init(frame:CGRect,shareImage:UIImage?,type:Int,shareModel:CommonShareModel?){
        self.init(frame: frame)
        self.shareImage = shareImage;
        self.shareType = JSHAREMediaType.init(rawValue: type)!
        self.shareModel = shareModel;
        if self.shareType == .JSHAREImage{
            if let image = self.shareImage{
                
                showViewTop.constant = CGFloat(UIDevice().navBarHeight)
                let imageV = UIImageView.init(image: image)
                imageV.image = image
                imageV.preventImageViewExtrudeDeformation()
                showView.backgroundColor = UIColor.clear
                contentView.addSubview(imageV)
                imageV.snp.makeConstraints { (make) in
                    make.centerY.centerX.equalTo(showView)
                    make.width.equalTo(image.size.width).priority(250)
                    make.height.equalTo(image.size.height)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 40)
                    make.height.lessThanOrEqualTo(imageV.snp.width)
                }
            }
        }
        if self.shareType == .JSHARELink{
            self.showView.isHidden = true
            self.scaleLb.isHidden = false
            
            var scaleHeight:Int = 175
            if  HHTool._IS_IPHONE_5(){
                scaleHeight = 148
            }else if HHTool._IS_IPHONE_6(){
                scaleHeight = 188
            }else if HHTool._IS_IPHONE_6P(){
                scaleHeight = 220
            }else if HHTool._IS_IPHONE_X(){
                scaleHeight = 270
            }
            
            self.scaleLbTop.constant = CGFloat(scaleHeight)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeContentViewAction))
             self.redenvelopeImageView.addGestureRecognizer(tap)
        }else if self.shareType == .JSHARERedenvelope{
           self.redenvelopeImageView.image = UIImage.loadImage("sc_com_icon_share_ clearance")
               self.showView.isHidden = true
            self.redenvelopeImageView.isHidden = true;
            let imageV:UIImageView = UIImageView.init(image: UIImage.loadImage("sc_com_icon_share_ clearance"))
            contentView.addSubview(imageV)
            imageV.snp.makeConstraints { (make) in
                make.centerX.equalTo(contentView)
                make.centerY.equalTo(contentView).offset(-30)
                make.width.equalTo(280)
                make.height.equalTo(427)
            }
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeContentViewAction))
            contentView.addGestureRecognizer(tap)
        }else{
            self.showView.isHidden = false
            self.redenvelopeImageView.isHidden = true
        }
        
//        let randomNumber:Int = Int(arc4random() % 20) + 75
        self.scaleLb.text = shareModel?.percentage
      
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.alphaComponentMake()
        contentView = loadViewFromNib()
        contentView.frame = frame
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
    
    func _share(PlatforType:Int){
        let shareEntity = ShareContentModel.init()
        shareEntity.title = shareModel?.title;
        shareEntity.thumbnail = shareModel?.thumbnail
        shareEntity.text = shareModel?.intro;
        if self.shareType == .JSHARELink || self.shareType == .JSHAREImage{
              shareEntity.url = shareModel?.url
             _shareMediaType(shareEntity: shareEntity, PlatforType: PlatforType, mediaType: JSHAREMediaType.JSHARELink.rawValue)
        }else  if self.shareType == .JSHARERedenvelope{
            shareEntity.image = shareModel?.urlImageData
            _shareMediaType(shareEntity: shareEntity, PlatforType: PlatforType, mediaType: JSHAREMediaType.JSHAREImage.rawValue)
            
        }else{
            shareEntity.text = "欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能！";
            _shareMediaType(shareEntity: shareEntity, PlatforType: PlatforType, mediaType: JSHAREMediaType.JSHAREText.rawValue)
        }
       
    }
    
    func _shareMediaType(shareEntity:ShareContentModel,PlatforType:Int,mediaType:Int){
        PublicShareService.share(shareEntity, platform:PlatforType, mediaType: mediaType) { (state, error) in
            if let error = error{
                HHTool.showError(error.localizedDescription)
            }
            
        }
    }
    
    
    @IBAction func shareWeChatAction(_ sender: UIButton) {
        _share(PlatforType: JSHAREPlatform.JSHAREPlatformWechatSession.rawValue)
    }
    
    @IBAction func shareCircleFriendsAction(_ sender: UIButton) {
        _share(PlatforType: JSHAREPlatform.JSHAREPlatformWechatTimeLine.rawValue)
    }
    
    
    @IBAction func shareQQAction(_ sender: UIButton) {
         _share(PlatforType: JSHAREPlatform.JSHAREPlatformQQ.rawValue)
    }
    
    
    @IBAction func shareSinaWeiboAction(_ sender: UIButton) {
        _share(PlatforType: JSHAREPlatform.JSHAREPlatformFacebook.rawValue)
    }
    
}
