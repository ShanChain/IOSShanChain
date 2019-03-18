//
//  JGUserLoginService.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/9.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit


typealias LoginComplete = (_ resultObject:Any? , _ error:NSError?) ->Void
typealias CreateChatRoomConversationComplete = (_ resultObject:JMSGConversation?, _ error:NSError?) ->Void

class JGUserLoginService: NSObject {
    
  // 设置极光用户信息
    open static func jg_SetUserInfo(nickNmae:String?, signature:String?,icon:String?, complete:@escaping JMSGCompletionHandler){
        
//        if let icon = icon {
//            let data = NSData.init(contentsOf: NSURL.fileURL(withPath: icon))
//            var str: String? = nil
//            if let aData = data {
//                str = String(data: aData as Data, encoding: .utf8)
//            }
//            let subData: Data? = str?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//            userInfo.avatarData = subData!
//        }
        
      
        EditInfoService.sc_editPersonalInfo(["name":nickNmae ?? "" ,"signature":signature ?? ""]) { (isSuccess) in
            complete(isSuccess,nil)
        }
        
        if let icon = icon{
            var headImage = UIImage.init(fromURLString: icon)
            headImage = headImage?.mc_reset(to: CGSize(width: 64, height: 64))
            headImage = headImage?.cutCircle()
            EditInfoService.sc_uploadImage(headImage, withCompressionQuality: 1.0) { (isSuccess) in
                
            }
        }
        
         let characterModel:SCCharacterModel =  SCCacheTool.shareInstance().characterModel
        JMSGUser.updateMyInfo(withParameter: characterModel.characterInfo.name, userFieldType: .fieldsNickname, completionHandler: nil)
        if characterModel.characterInfo.headImg != nil{
            let image = UIImage.init(fromURLString: characterModel.characterInfo.headImg)
            if let image = image{
                if let imageData = UIImagePNGRepresentation(image){
                    JMSGUser.updateMyInfo(withParameter: imageData, userFieldType: .fieldsAvatar, completionHandler: nil)
                }
            }
            
        }
        
        
    }
    
  // 极光登录
  open static func  jg_userLogin(username: String, password: String , loginComplete:@escaping LoginComplete ){
        JMSGUser.login(withUsername: username, password: password) { (result, error) in
            if error == nil {
                UserDefaults.standard.set(username, forKey: kLastUserName)
                JMSGUser.myInfo().thumbAvatarData({ (data, id, error) in
                    if let data = data {
                        let imageData = NSKeyedArchiver.archivedData(withRootObject: data)
                        UserDefaults.standard.set(imageData, forKey: kLastUserAvator)
                    } else {
                        UserDefaults.standard.removeObject(forKey: kLastUserAvator)
                    }
                })
                let characterModel:SCCharacterModel =  SCCacheTool.shareInstance().characterModel
                
                DispatchQueue.global().async {
                    JGUserLoginService.jg_SetUserInfo(nickNmae: characterModel.characterInfo.name, signature: characterModel.characterInfo.signature, icon: characterModel.characterInfo.headImg, complete: { (result, error) in
                        if error == nil{
                          printLog("极光信息更新成功")
                        }
                    })
                }
                
                
         
                
                UserDefaults.standard.set(username, forKey: kCurrentUserName)
                UserDefaults.standard.set(password, forKey: kCurrentUserPassword)

                loginComplete(result,nil)
            }else{
                loginComplete(nil,error! as NSError)
            }
            
        }
    }
    
    // 获取会话
    open static  func jg_createChatRoomConversation(roomId:String , callBlock:@escaping CreateChatRoomConversationComplete){
        
        if let roomConversation = JMSGConversation.chatRoomConversation(withRoomId: roomId){
            callBlock(roomConversation,nil)
            return
        }
        
        JMSGConversation.createChatRoomConversation(withRoomId:roomId) { (result, error) in
            
            guard let conversation = result as? JMSGConversation else{
                callBlock(nil,error! as NSError)
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateConversation), object: nil, userInfo: nil)
            callBlock(conversation,nil)
        }
    }
    
    // 自动登录极光
    open static func jg_automaticLogin(loginComplete:@escaping LoginComplete){
        let userName:String? = UserDefaults.standard.object(forKey: kCurrentUserName) as? String
        let password:String? = UserDefaults.standard.object(forKey: kCurrentUserPassword) as? String
        if (userName != nil) && (password != nil) {
            jg_userLogin(username: userName! , password: password! , loginComplete: loginComplete)
        }else{
            loginComplete(nil,nil)
        }
        
    }
    
   // 加入聊天室
    open static func jg_enterchatRoom(roomId:String , callBlock:@escaping CreateChatRoomConversationComplete){
        
        // 先异步获取聊天室的Conversation列表
        JMSGConversation.allChatRoomConversation { (result, error) in
            if error != nil {
                if (error as NSError?)?.code == 863004 {
                    // 未登录
                    self.jg_automaticLogin(loginComplete: { (loginResult, loginError) in
                        if loginError == nil{
                            // 获取聊天室会话并根据会话加入聊天室
                           self.jg_getConversationEnterChatRoom(roomId: roomId, callBlock: callBlock)
                        }else{
                            HHTool.showError(loginError?.localizedDescription)
                        }
                    })
                } else {
                    self.jg_getConversationEnterChatRoom(roomId: roomId, callBlock: callBlock)
                }
                return
            }
            
            if let conversations = result as? [JMSGConversation]{
                var isEnter = false
                if conversations.count > 0 {
                    for (_,chatRoomConversation) in  conversations.enumerated(){
                        if chatRoomConversation.target is JMSGChatRoom{
                            if (chatRoomConversation.target as? JMSGChatRoom)?.roomID == roomId{
                              isEnter = true
                                EditInfoService.enterChatRoom(withId: roomId,  show: "", call: { (result, error) in
                                     callBlock(result as! JMSGConversation?,error as NSError?)
                                })
                            }
                        }
                    }
                    
                }
                if !isEnter {
                    self.jg_getConversationEnterChatRoom(roomId: roomId, callBlock: callBlock)
                }
            }
            
        }
    }
    
    // 获取聊天室会话并根据会话加入聊天室
    open static func jg_getConversationEnterChatRoom(roomId:String , callBlock:@escaping CreateChatRoomConversationComplete){
        self.jg_createChatRoomConversation(roomId: roomId, callBlock: { (conversation, createConversationError) in
            if createConversationError == nil{
                // 创建会话成功 加入聊天室
//                EditInfoService.enterChatRoom(withId: roomId, call: callBlock as! (JMSGConversation?, Error?) -> Void as! (Any?, Error?) -> Void)
                
                EditInfoService.enterChatRoom(withId: roomId, show: "", call: { (result, error) in
                    callBlock(result as! JMSGConversation?,error as NSError?)
                })
                
                return
            }
            if createConversationError?.code == 863004{
                SCAppManager.shareInstance().logout()
                return
            }
            HHTool.showError(createConversationError?.localizedDescription)
        })
        
    }

}





