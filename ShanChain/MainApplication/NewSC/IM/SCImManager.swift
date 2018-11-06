//
//  SCImManager.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/10/23.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation


public let CUSTOM_CONTENT =  "CUSTOM_CONTENT"
public let CUSTOM_REWARD =   "CUSTOM_REWARD"
public let CUSTOM_COMPLETETIME = "CUSTOM_COMPLETETIME"
public let TEST_ROOM_ID   = "15198852"


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
