//
//  AppDelegate+JMessage.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/27.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation
import JMessage


//MARK: - JMessage Delegate
extension AppDelegate: JMessageDelegate {
    public func onDBMigrateStart() {
        MBProgressHUD_JChat.showMessage(message: "数据库升级中", toView: nil)
    }
    
   public func onDBMigrateFinishedWithError(_ error: Error!) {
        MBProgressHUD_JChat.hide(forView: nil, animated: true)
        MBProgressHUD_JChat.show(text: "数据库升级完成", view: nil)
    }
    public func onReceive(_ event: JMSGUserLoginStatusChangeEvent!) {
        switch event.eventType.rawValue {
        case JMSGLoginStatusChangeEventType.eventNotificationLoginKicked.rawValue,
             JMSGLoginStatusChangeEventType.eventNotificationServerAlterPassword.rawValue,
             JMSGLoginStatusChangeEventType.eventNotificationUserLoginStatusUnexpected.rawValue:
            _logout()
        default:
            break
        }
    }
    public func onReceive(_ event: JMSGFriendNotificationEvent!) {
        switch event.eventType.rawValue {
        case JMSGFriendEventType.eventNotificationReceiveFriendInvitation.rawValue,
             JMSGFriendEventType.eventNotificationAcceptedFriendInvitation.rawValue,
             JMSGFriendEventType.eventNotificationDeclinedFriendInvitation.rawValue:
            cacheInvitation(event: event)
        case JMSGFriendEventType.eventNotificationDeletedFriend.rawValue,
             JMSGFriendEventType.eventNotificationReceiveServerFriendUpdate.rawValue:
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        default:
            break
        }
    }
    
    private func cacheInvitation(event: JMSGNotificationEvent) {
        let friendEvent =  event as! JMSGFriendNotificationEvent
        let user = friendEvent.getFromUser()
        let reason = friendEvent.getReason()
        let info = JCVerificationInfo.create(username: user!.username, nickname: user?.nickname, appkey: user!.appKey!, resaon: reason, state: JCVerificationType.wait.rawValue)
        switch event.eventType.rawValue {
        case JMSGFriendEventType.eventNotificationReceiveFriendInvitation.rawValue:
            info.state = JCVerificationType.receive.rawValue
            JCVerificationInfoDB.shareInstance.insertData(info)
        case JMSGFriendEventType.eventNotificationAcceptedFriendInvitation.rawValue:
            info.state = JCVerificationType.accept.rawValue
            JCVerificationInfoDB.shareInstance.updateData(info)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        case JMSGFriendEventType.eventNotificationDeclinedFriendInvitation.rawValue:
            info.state = JCVerificationType.reject.rawValue
            JCVerificationInfoDB.shareInstance.updateData(info)
        default:
            break
        }
        if UserDefaults.standard.object(forKey: kUnreadInvitationCount) != nil {
            let count = UserDefaults.standard.object(forKey: kUnreadInvitationCount) as! Int
            UserDefaults.standard.set(count + 1, forKey: kUnreadInvitationCount)
        } else {
            UserDefaults.standard.set(1, forKey: kUnreadInvitationCount)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateVerification), object: nil)
    }

    
    func _logout() {
        JCVerificationInfoDB.shareInstance.queue = nil
        UserDefaults.standard.removeObject(forKey: kCurrentUserName)
        let alertView = UIAlertView(title: "您的账号在其它设备上登录", message: "", delegate: self, cancelButtonTitle: "重新登录")
        alertView.show()
    }
    

}

extension AppDelegate: UIAlertViewDelegate {
    
    
    
    private func pushToLoginView() {
        UserDefaults.standard.removeObject(forKey: kCurrentUserPassword)
        SCAppManager.shareInstance().logout()
//        if let appDelegate = UIApplication.shared.delegate,
//            let window = appDelegate.window {
//            window?.rootViewController = JCNavigationController(rootViewController: JCLoginViewController())
//        }
    }
    
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//        if buttonIndex == 1 {
//            guard let username = UserDefaults.standard.object(forKey: kLastUserName) as? String  else {
//                pushToLoginView()
//                return
//            }
//            guard let password = UserDefaults.standard.object(forKey: kCurrentUserPassword) as? String else {
//                pushToLoginView()
//                return
//            }
//            MBProgressHUD_JChat.showMessage(message: "登录中", toView: nil)
//            JMSGUser.login(withUsername: username, password: password) { (result, error) in
//                MBProgressHUD_JChat.hide(forView: nil, animated: true)
//                if error == nil {
//                    UserDefaults.standard.set(username, forKey: kLastUserName)
//                    UserDefaults.standard.set(username, forKey: kCurrentUserName)
//                    UserDefaults.standard.set(password, forKey: kCurrentUserPassword)
//                } else {
//                    self.pushToLoginView()
//                    MBProgressHUD_JChat.show(text: "\(String.errorAlert(error! as NSError))", view: self.window?.rootViewController?.view, 2)
//                }
//            }
//        } else {
//            pushToLoginView()
//        }
        pushToLoginView()
    }
}
