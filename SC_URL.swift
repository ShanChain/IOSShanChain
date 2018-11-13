//
//  SC_URL.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/9.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation

public let TASK_ADD_URL = "/v1/task/add" //添加任务
public let TASKCOMMENT_URL  = "/v1/taskComment/query" //查询任务评论列表
public let TASKCOMMENT_ADD_URL  = "/v1/taskComment/add" //添加任务评论
public let TASK_SUPPORT_URL  = "/v1/task/support/add" //添加任务点赞
public let TASK_COMMENT_SUPPORT_URL  = "/v1/taskComment/support/add" //添加评论点赞
public let TASK_COMMENT_SUPPORT_REMOVE_URL  = "/v1/taskComment/support/remove" //取消评论点赞
public let TASK_DETAILS_URL  = "/v1/task/detail" //任务详情
public let TASK_RECEIVE_URL  = "/v1/task/receive" //任务领取

// 我的任务
public let ROOMTASK_LIST_URL  = "/v1/task/roomtask/list" //查询广场所有任务列表
public let NACCALIMED_LIST_URL  = "/v1/task/unaccalimed/list" //查询广场未领取任务列表

public let INDIVIDUAL_LIST_URL  = "/v1/task/individual/list" //查询个人全部任务列表
public let PUBLISHTASK_LIST_URL  = "/v1/task/publishtask/list" //查询个人发布任务列表
public let RECEIVETASK_LIST_URL  = "/v1/task/receivetask/list" //查询个人领取任务列表
public let ENDTASK_LIST_URL  = "/v1/task/endtask/list" //查询个人已结束任务列表

