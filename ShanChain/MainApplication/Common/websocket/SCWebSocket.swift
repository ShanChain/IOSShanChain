//
//  SCWebSocket.swift
//  ShanChain
//
//  Created by 千千世界 on 2019/5/24.
//  Copyright © 2019 ShanChain. All rights reserved.
//

import UIKit
import Starscream

@objc class SCWebSocket: NSObject {
    //ws://test.qianqianshijie.com:8081/websocket/{101471}
//    let host = "ws://test.qianqianshijie.com:8081/websocket/101471"
    @objc public var socket: WebSocket!
    
    static let manager = SCWebSocket()
    
    @objc class func share() -> SCWebSocket {
        return manager
    }
    
    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "kNetworkReachabilityChangedNotification"), object: nil)
        
    }
    
    @objc public func openWebSocket() {
        
        guard let userId = SCCacheTool.shareInstance()?.getCurrentUser() else {
            print("用户ID为空")
            return
        }
        print("用户ID:\(userId)")
        // 这里 url 需要根据环境改变 。测试->ws://test.qianqianshijie.com 生产->ws://api.qianqianshijie.com
        var request = URLRequest(url: URL(string: String(format: "ws://api.qianqianshijie.com:8081/websocket/%@", userId))!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
    }
    @objc public func closeWebSocket() {
        guard socket != nil else {
            return
        }
        if socket.isConnected {
            socket.disconnect()
        }        
        socket.delegate = nil
        socket = nil
        
    }
    /// 发送消息事件
    @objc public func sendWebSocket(_ data: Dictionary<String, Any>) {
        if socket.isConnected {
            // 已连接
            let tmp = data
            if let d = try? JSONSerialization.data(withJSONObject: tmp, options: JSONSerialization.WritingOptions.prettyPrinted) {
                
                if let str = String(data: d, encoding: String.Encoding.utf8) {
                    socket.write(string: str)
                }
                
            }

        }else {
            // 未连接
            socket.connect()
        }
        
        
    }
    /// 网络监测通知
    @objc func reachabilityChanged(note: NSNotification) {
        
        if let curReach = note.object as? Reachability {
            let status = curReach.currentReachabilityStatus()
            switch status {
            case NotReachable:
                // 没有网
                HHTool.showTip("当前网络断开，请检查网络", duration: 1)
            default :
                if !socket.isConnected {
                    socket.connect()
                }
            }
        }
    }
}

extension SCWebSocket: WebSocketDelegate {
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("连接成功")
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("连接断开")
        if let e = error as? WSError {
            print("websocket 1 disconnected: \(e.message)")
        } else if let e = error {
            print("websocket 2 disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
        for _ in 0...100 {
            if socket.isConnected {
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if !socket.isConnected {
                    socket.connect()
                }
            }
        }
        
//        if JCNetworkManager.isNotReachable {
//            // 没有网络
//        }else {
//            socket.connect()
//        }

    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        // 收到服务端的消息 ->统一处理
        print("Received text: \(text)")
        
        let data = text.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {

            if let code = dict["code"] as? String,let type = dict["type"] as? String,let data = dict["data"] as? [AnyHashable : Any] {
                
                if code == "00000000" {
                    NotificationCenter.default.post(name: Notification.Name(type), object: self, userInfo: data)
                }else {
                    // 错误码
                    HHTool.showTip(code, duration: 1)
                }
            }
            
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
        
    }
}

extension Notification.Name {
    /// ARSPaySuccess 支付成功
    static let ARSPaySuccess = Notification.Name("ARSPaySuccess")
    /// SysMessage 进入下一层的条件成立
    static let SysMessage = Notification.Name("SysMessage")
    /// confirmNum 时间到 -> 确认结束
    static let confirmNum = Notification.Name("confirmNum")
}
