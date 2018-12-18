//
//  SC_URL.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/9.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation


/*
 公共接口
 */
public let  RealNameVerified_URL = "/v1/2.0/Verified" // 实名认证
public let  IsSuper_URL  = "/web/api/sys/isSuper" //是否是超级用户
public let  WALLET_CURRENCY_URL  = "/web/api/wallet/seat/currency" // 获取当前汇率

/*
  卡劵相关
 */

public let  VendorGet_URL = "/wallet/api/coupons/vendor/get" // 创建方获取卡券详情
public let  CreateCoupons_URL = "/wallet/api/coupons/vendor/create" // 创建卡劵
public let  CouponsVendorList_URL = "/wallet/api/coupons/vendor/list" // 获取当前用户可领取卡券列表
public let  CouponsVendorDetails_URL = "/wallet/api/coupons/vendor/Get" // 获取当前卡劵详情

public let  User_Create_List_URL = "/wallet/api/coupons/vendor/createList" // 获取用户已发布的卡券列表

public let  User_Receive_List_URL = "/wallet/api/coupons/client/getList" // 获取用户已领取的子卡券列表


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

public let RECEIVE_ACCOMPLISH_URL  = "/v1/task/receive/accomplish" //完成领取任务
public let TASK_CANCEL_URL  = "/v1/task/cancel" //取消任务
public let CONFIRM_UNDONE_URL  = "/v1/task/confirm/undone" //未完成
public let TASK_CONRIRM_COMPLETE_URL  = "/v1/task/confirm/complete" //发布者确认对方完成
public let TASK_URGE_URL  = "/v1/task/urge" //催促确认/完成任务

public let COORDINATE_URL  = "/v1/lbs/coordinate/info" // 获取当前位置聊天室信息


public let JM_RoomMembers_URL  = "/jm/room/RoomMembers" //获取极光聊天室成员信息


