//
//  SC_URL.swift
//  ShanChain
//
//  Created by 千千世界 on 2018/11/9.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

import Foundation

/*
 元社区相关
 */

public let  HotChatRoom_URL = "/web/api/sys/hotChatRoom" // 热门元社区
public let  ShareRoom_URL = "/v1/2.0/share/shareRoom" // 分享聊天室
public let  AddFocus_URL = "/v1/focus/focus" // 添加关注


/*
 公共接口
 */
public let  RealNameVerified_URL = "/v1/2.0/Verified" // 实名认证
public let  IsSuper_URL  = "/web/api/sys/isSuper" //是否是超级用户
public let  WALLET_CURRENCY_URL  = "/web/api/wallet/seat/currency" // 获取当前汇率
public let  WALLET_ADDRESSINFO_URL  = "/web/api/wallet/info" // 用户查询马甲账户信息API
public let  GetVerifycode_URL  = "/v1/2.0/sms/login/verifycode" // 获取验证码
public let  checkUpdate_URL  = "/oss/apk/get/latest" // 检查更新


/*
  卡劵相关
 */

public let  VendorGet_URL = "/wallet/api/coupons/vendor/get" // 创建方获取卡券详情
public let  CheckVendor_URL = "/wallet/api/coupons/vendor/check" // 判定当前卡券代号是否可用
public let  CreateCoupons_URL = "/wallet/api/coupons/vendor/create" // 创建卡劵
public let  CouponsVendorList_URL = "/wallet/api/coupons/vendor/list" // 获取当前用户可领取卡券列表
public let  CouponsVendorDetails_URL = "/wallet/api/coupons/vendor/Get" // 获取当前卡劵详情

public let  User_Create_List_URL = "/wallet/api/coupons/vendor/createList" // 获取用户已发布的卡券列表

public let  User_Receive_List_URL = "/wallet/api/coupons/client/getList" // 获取用户已领取的子卡券列表

public let  User_Receive_Details = "/wallet/api/coupons/client/Get" // 获取卡券详情

public let  User_UseCoupons_URL = "/wallet/api/coupons/client/useCoupons" // 核销子卡券

public let  User_ClientList_URL = "/wallet/api/coupons/vendor/clientList" // 发券人获取领券人员详情

public let  ReceiveCoupons_URL = "/wallet/api/coupons/client/getCoupons" //领取卡券生成子卡券


/*
 任务相关
 */
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


/*
  设置
 */
public let User_Bind_URL  = "/v1/user/bound" //查看绑定情况
public let User_Bind_Account_URL  = "/v1/user/bind_other_account" //绑定账号/解绑账号
public let Unlogin_Verifycode_URL  = "/v1/2.0/sms/setting/verifycode" //重置密码获取验证码
public let Reset_Password_URL  = "/v1/2.0/user/reset_password" //重置密码
public let Change_phone_URL  = "/v1/2.0/user/change_phone" //修改手机号
public let RealVerified_detail_URL  = "/v1/2.0/Verified/detail" //实名认证详情
public let Jpush_AllowNotify_URL  = "/push/jpush/allowNotify" //用户设置是否接受系统通知


/*
 钱包
 */

public let GetWalletPassword_URL  = "/wallet/api/wallet/2.0/hideInfo" //获取用户密码


