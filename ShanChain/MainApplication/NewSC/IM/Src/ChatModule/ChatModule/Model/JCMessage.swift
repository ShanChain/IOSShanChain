//
//  JCMessage.swift
//  JChat
//
//  Created by deng on 10/04/2017.
//  Copyright © 2017 HXHG. All rights reserved.
//

import UIKit
import JMessage

open class JCMessage: NSObject, JCMessageType {

    init(content: JCMessageContentType) {
        self.content = content
        self.options = JCMessageOptions(with: content)
        super.init()
    }
    
    open let identifier: UUID = .init()
    open var msgId = ""
    open var name: String = "UserName"
    open var date: Date = .init()
    open var sender: JMSGUser?
    open var senderAvator: UIImage?
    open var receiver: JMSGUser?
    open var content: JCMessageContentType
    open let options: JCMessageOptions
    open var updateSizeIfNeeded: Bool = false
    open var unreadCount: Int = 0  //消息未读数
    open var targetType: MessageTargetType = .single
    open var contentType:JMSGContentType = .text
}

extension JMSGMessage {
    typealias Callback = (JMSGMessage, Data) -> Void
   // 解析消息，得到JCMessage
    func parseMessage(_ delegate: JCMessageDelegate, _ updateMediaMessage: Callback? = nil) -> JCMessage {

        var msg: JCMessage!
        let currentUser = JMSGUser.myInfo()
        let isCurrent = fromUser.isEqual(to: currentUser)
        let state = self.ex.state
        let isGroup = targetType == .group
        let isChatRoom = targetType == .chatRoom
       
        
        switch(contentType) {
        case .text:
            if ex.isBusinessCard {
                let businessCardContent = JCBusinessCardContent()
                businessCardContent.delegate = delegate
                businessCardContent.appKey = ex.businessCardAppKey
                businessCardContent.userName = ex.businessCardName
                msg = JCMessage(content: businessCardContent)
            } else {
                let content = self.content as! JMSGTextContent
                msg = JCMessage(content: JCMessageTextContent(text: content.text))
            }
        case .image:
            let content = self.content as! JMSGImageContent
            let imageContent = JCMessageImageContent()
            imageContent.imageSize = content.imageSize
            if ex.isLargeEmoticon {
                imageContent.imageSize = CGSize(width: content.imageSize.width / 3, height: content.imageSize.height / 3)
            }
            if state == .sending {
                content.uploadHandler = {  (percent:Float, msgId:(String?)) -> Void in
                    imageContent.upload?(percent)
                }
            }
            imageContent.delegate = delegate
            msg = JCMessage(content: imageContent)

            if let path = content.thumbImageLocalPath {
                let image = UIImage(contentsOfFile: path)
                imageContent.image = image
                msg.content = imageContent
            } else {
                content.thumbImageData({ (data, id, error) in
                    if let data = data {
                        if let updateMediaMessage = updateMediaMessage {
                            updateMediaMessage(self, data)
                        }
                    }
                })
            }
        case .eventNotification:
            let content = self.content as! JMSGEventContent
            let noticeContent = JCMessageNoticeContent(text: content.showEventNotification())
            msg = JCMessage(content: noticeContent)
            msg.options.showsTips = false
        case .voice:
            let content = self.content as! JMSGVoiceContent
            let voiceContent = JCMessageVoiceContent()
            voiceContent.duration = TimeInterval(content.duration.intValue)
            voiceContent.delegate = delegate
            msg = JCMessage(content: voiceContent)
            content.voiceData({ (data, id, error) in
                if let data = data {
                    voiceContent.data = data
                }
            })
        case .file:
            let content = self.content as! JMSGFileContent
            if ex.isShortVideo {
                let videoContent = JCMessageVideoContent()
                videoContent.delegate = delegate
                msg = JCMessage(content: videoContent)
                if let path = content.originMediaLocalPath {
                    let url = URL(fileURLWithPath: path)
                    videoContent.data = try! Data(contentsOf: url)
                } else {
                    content.fileData({ (data, id, error) in
                        if let data = data {
                            if let updateMediaMessage = updateMediaMessage {
                                updateMediaMessage(self, data)
                            }
                        }
                    })
                }
                videoContent.fileContent = content
            } else {
                let fileContent = JCMessageFileContent()
                fileContent.delegate = delegate
                fileContent.fileName = content.fileName
                fileContent.fileType = ex.fileType
                fileContent.fileSize = ex.fileSize
                if let path = content.originMediaLocalPath {
                    let url = URL(fileURLWithPath: path)
                    fileContent.data = try! Data(contentsOf: url)
                }
                msg = JCMessage(content: fileContent)
            }
        case .location:
            let content = self.content as! JMSGLocationContent
            let locationContent = JCMessageLocationContent()
            locationContent.address = content.address
            locationContent.lat = content.latitude.doubleValue
            locationContent.lon = content.longitude.doubleValue
            locationContent.delegate = delegate
            msg = JCMessage(content: locationContent)
        case .prompt:
            let content = self.content as! JMSGPromptContent
            let noticeContent = JCMessageNoticeContent(text: content.promptText)
            msg = JCMessage(content: noticeContent)
            msg.options.showsTips = false
        case .custom:
            let content = self.content as! JMSGCustomContent
            if  let customDictionary = content.customDictionary{
                let taskContent = HHPublishTaskContent(customDictionary: customDictionary as! Dictionary<String, Any>, delegate: delegate)
                msg = JCMessage(content: taskContent)
            }
            
        default:
            msg = JCMessage(content: JCMessageNoticeContent.unsupport)
        }
        if msg.options.alignment != .center {
            msg.options.alignment = isCurrent ? .right : .left
            if isGroup || isChatRoom{
                msg.options.showsCard = !isCurrent
            }
        }
    
        switch targetType {
        case .group:
            msg.targetType = .group
        case .chatRoom:
            msg.targetType = .chatRoom
        default:
            msg.targetType = .single
        }
        
        msg.msgId = self.msgId
        msg.options.state = state
//        if isCurrent {
//            msg.senderAvator = UIImage.getMyAvator()
//        }
        
        fromUser.thumbAvatarData { (data, username, error) in
            if let imageData = data {
                let image = UIImage(data: imageData)
                 msg.senderAvator = image
            } else {
                 msg.senderAvator = UIImage.loadImage("com_icon_user_80")
            }
        }
        
        if fromUser.username == "154269377600600163e0aa658733729" {
           
        }
        
        msg.contentType = contentType
        msg.sender = fromUser
        msg.name = fromName
      //  msg.name = fromUser.displayName()
        msg.unreadCount = getUnreadCount()
        return msg
    }
}

