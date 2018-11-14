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
        
        let userInfo = JMSGUserInfo()
//        if let icon = icon {
//            let data = NSData.init(contentsOf: NSURL.fileURL(withPath: icon))
//            var str: String? = nil
//            if let aData = data {
//                str = String(data: aData as Data, encoding: .utf8)
//            }
//            let subData: Data? = str?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//            userInfo.avatarData = subData!
//        }
        
        userInfo.signature = signature ?? ""
        userInfo.nickname = nickNmae ?? ""
        JMSGUser.updateMyInfo(with: userInfo, completionHandler: complete)
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

}






