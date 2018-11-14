//
//  TaskListModel.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/13.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import UIKit

class TaskListModel: HandyJSON {

    var bounty:String?
    var characterId:String?
    var commentCount:String?
    var createTime:String? //发布时间
    var ReceiveTime:String? //领取时间
    var expiryTime:String? //完成时间
    var intro:String?
    var receiveCount:String?
    var status:String?
    var supportCount:String?
    var taskId:String?
    var topping:String?
    var userId:String?
    var verify:String?
    var verifyTime:String? //确认时间
    var headImg:String?
    var name:String?
    var roomName:String?
    
    // 全部任务中 任务是否被领取
    var isReceived:Bool{
        return Int(status!)! > 5
    }
    
    // 是否是我发布的  false:我领取的
    var isMyBublish:Bool{
        let currentCharacterId:String = SCCacheTool.shareInstance().getCurrentCharacterId()
        if (Int(currentCharacterId)! == Int(characterId!)!){
            return true
        }
        return false
    }
    
    var backViewLeftBtnTuple:(title:String,isShow:Bool,color:UIColor,isClick:Bool,width:Int){
        if Int(status!)! == 10 {
            if isMyBublish == false{
                return ("取消任务",true,SC_ThemeMainColor,true,100)
            }
            return ("",false,SC_ThemeBackgroundViewColor,false,0)
        }
        
        if Int(status!)! == 15 {
            if isMyBublish == true{
                return ("未完成",true,SC_ThemeMainColor,true,80)
            }
            return ("",false,SC_ThemeBackgroundViewColor,false,0)
        }
        
         return ("",false,SC_ThemeBackgroundViewColor,false,0)
    }
    
    var backViewCenterBtnTuple:(title:String,isShow:Bool,color:UIColor,isClick:Bool,width:Int){
        if Int(status!)! == 10 {
            if isMyBublish == true{
                return ("催他完成",true,SC_ThemeMainColor,true,100)
            }
            return ("",false,SC_ThemeBackgroundViewColor,false,0)
        }
        
        if Int(status!)! == 15 {
            if isMyBublish == false{
                return ("请等待赏主确认完成情况!",true,SC_ThemeMainColor,false,220)
            }
            return ("",false,SC_ThemeBackgroundViewColor,false,0)
        }
        
        if Int(status!)! == 20 {
            return ("任务已完成",true,SC_ThemeBackgroundViewColor,false,120)
        }
        
        if Int(status!)! == 21 {
            return ("确认任务未完成",true,SC_ThemeBackgroundViewColor,false,160)
        }
        
        if Int(status!)! == 22 {
            return ("任务超时",true,SC_ThemeBackgroundViewColor,false,100)
        }
        
        if Int(status!)! == 25 {
            return ("任务取消",true,SC_ThemeBackgroundViewColor,false,100)
        }
        return ("任务取消",true,SC_ThemeBackgroundViewColor,false,100)
    }
    
    var backViewRightBtnTuple:(title:String,isShow:Bool,color:UIColor,isClick:Bool,width:Int){
        if Int(status!)! == 10 {
            if isMyBublish == false{
                return ("已完成",true,SC_ThemeMainColor,true,60)
            }
            return ("",false,SC_ThemeBackgroundViewColor,false,0)
        }
        
        if Int(status!)! == 15 {
            if isMyBublish == true{
                return ("确认完成",true,SC_ThemeMainColor,true,80)
            }
            return ("",false,SC_ThemeBackgroundViewColor,false,0)
        }
        
         return ("",false,SC_ThemeBackgroundViewColor,false,0)
        
    }
    
    var personalStatusBtnTuple:(title:String,isClick:Bool,width:Int){
        if Int(status!)! == 10 {
            return ("正在完成",true,80)
        }
        
        if Int(status!)! == 15 {
            return ("待赏主确认",false,100)
        }
        
        if Int(status!)! == 20 {
            return ("已完成",true,60)
        }
        
        if Int(status!)! == 21 {
            return ("任务失败",false,80)
        }
        
        if Int(status!)! == 22 {
            return ("任务超时",false,80)
        }
        
        if Int(status!)! == 25 {
            return ("任务取消",false,80)
        }
        
        return ("任务失效",false,80)
    }
    
    
    required init() {}
}