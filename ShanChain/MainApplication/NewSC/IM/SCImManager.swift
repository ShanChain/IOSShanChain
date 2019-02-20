//
//  SCImManager.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/23.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation


public let CUSTOM_CONTENT =  "dataString"
public let CUSTOM_REWARD =   "bounty"
public let CUSTOM_COMPLETETIME = "time"
public let CUSTOM_TASKID = "taskId"
public let TEST_ROOM_ID   = "15198852"


public let JMSSAGE_APPKEY   = "0a20b6277a625655791e3cd9"
public let JM_APPKET   =   "appkey"
public let JM_USERNAME   = "userName"
public let JM_COMVERSATION_TYPE  = "conversationType" // 会话类型

public let SC_AUTHCODE = "authCode"



typealias Task = (_ cancel : Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancel(_ task: Task?) {
    task?(true)
}
