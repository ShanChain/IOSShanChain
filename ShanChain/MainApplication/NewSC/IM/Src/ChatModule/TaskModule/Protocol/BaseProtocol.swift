//
//  BaseProtocol.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation

protocol TaskListCellProtocol: NSObjectProtocol {
    func callBack(listModel: TaskListModel)
    func _clickAvatar(listModel: TaskListModel) // 点击头像
    func receiveCompleted(listModel: TaskListModel,view:TaskListBackView) // 领取方已完成
    func receiveCancel(listModel: TaskListModel,view:TaskListBackView) // 领取方取消任务
    func publishConfirmUndone(listModel: TaskListModel,view:TaskListBackView) // 发布方点击未完成
    func publishConfirmComplete(listModel: TaskListModel,view:TaskListBackView)//发布者确认对方完成
    func urgeComplete(listModel: TaskListModel,view:TaskListBackView) // 催促确认/完成任务
    
}
