//
//  NotificationHandler.h
//  ShanChain
//
//  Created by flyye on 2017/12/11.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

//msg_key
static NSString * const MSG_KEY_WORLDVIEW_ILLEGAL = @"MSG_WORLDVIEW_ILLEGAL";//世界观因违规被暂停 消息编号：
static NSString * const MSG_KEY_CHARACTER_BE_FOCUS = @"MSG_CHARACTER_BE_FOCUS";//你的当前人物被@
static NSString * const MSG_KEY_STORY_BE_COMMENT = @"MSG_STORY_BE_COMMENT";//有人评论了我
static NSString * const MSG_KEY_STORY_BE_PRAISE = @"MSG_STORY_BE_PRAISE";//有人赞了我的故事
static NSString * const MSG_KEY_COMMENT_BE_PRAISE = @"MSG_COMMENT_BE_PRAISE";//有人赞了我的评论
static NSString * const MSG_KEY_DYNAMIC_BE_FORWARD = @"MSG_DYNAMIC_BE_FORWARD";//有人转发了我
static NSString * const MSG_KEY_BE_REPORT = @"MSG_BE_REPORT";//我被举报并处理
static NSString * const MSG_KEY_REPORT_WILL_BE_DEAL_WITH = @"MSG_REPORT_WILL_BE_DEAL_WITH";//待处理的举报
static NSString * const MSG_KEY_FRIEND_RECOMMEND = @"MSG_FRIEND_RECOMMEND";//好友推荐
static NSString * const MSG_KEY_CHARACTER_BE_FOLLOW = @"MSG_CHARACTER_BE_FOLLOW";//有人关注了你
static NSString * const MSG_KEY_BE_FOCUS_AT_CHAT = @"MSG_BE_FOCUS_AT_CHAT";//对话场景推荐
static NSString * const MSG_KEY_APPLY_JOIN_GROUP = @"MSG_APPLY_JOIN_GROUP";//有人申请加入场景
static NSString * const MSG_KEY_APPLY_JOIN_GROUP_OK = @"MSG_APPLY_JOIN_GROUP_OK";//申请加入场景通过
static NSString * const MSG_KEY_BE_INVITATION_JOIN_GROUP = @"MSG_BE_INVITATION_JOIN_GROUP";//被拉进对话场景
static NSString * const MSG_KEY_CHARACTER_CHAT = @"MSG_CHARACTER_CHAT";//单人对话消息
static NSString * const MSG_KEY_GROUP_CHAT = @"MSG_GROUP_CHAT";//多人对话消息
static NSString * const MSG_KEY_BE_FOCUS_AT_GROUP = @"MSG_BE_FOCUS_AT_GROUP";//场景中被@
static NSString * const MSG_KEY_DRAMAS_BE_COMMING = @"MSG_DRAMAS_BE_COMMING";//大戏预告
static NSString * const MSG_KEY_DRAMAS_BE_CANCEL = @"MSG_DRAMAS_BE_CANCEL";//大戏取消
static NSString * const MSG_KEY_DRAMAS_WILL_START = @"MSG_DRAMAS_WILL_START";//大戏即将开始
static NSString * const MSG_KEY_DRAMAS_START = @"MSG_DRAMAS_START";//大戏开始
static NSString * const MSG_KEY_DRAMAS_SOMEONE_SIGN = @"MSG_DRAMAS_SOMEONE_SIGN";//大戏中有人签到
static NSString * const MSG_KEY_DRAMAS_SOMEONE_OUT = @"MSG_DRAMAS_SOMEONE_OUT";//大戏中有人签退
static NSString * const MSG_KEY_DRAMAS_OVER = @"MSG_DRAMAS_OVER";//大戏结束
static NSString * const MSG_KEY_DRAMAS_NEW_NOTICE = @"MSG_DRAMAS_NEW_NOTICE";//场景新公告
static NSString * const MSG_KEY_DRAMAS_CONETNT_UPDATE = @"MSG_DRAMAS_CONETNT_UPDATE";//场景信息修改
static NSString * const MSG_KEY_SOMEONT_JOIN_GROUP = @"MSG_SOMEONT_JOIN_GROUP";//有人加入了场景
static NSString * const MSG_KEY_SOMEONE_OUT_GROUP = @"MSG_SOMEONE_OUT_GROUP";//有人离开了场景
static NSString * const MSG_KEY_SOMEONE_BE_OUT_GROUP = @"MSG_SOMEONE_BE_OUT_GROUP";//被请出对话场景
static NSString * const MSG_KEY_GET_GROUP_MANAGER_RIGHT = @"MSG_GET_GROUP_MANAGER_RIGHT";//获得场景管理权限
static NSString * const MSG_KEY_LOST_GROUP_MANAGER_RIGHT = @"MSG_LOST_GROUP_MANAGER_RIGHT";//失去场景管理权限
static NSString * const MSG_KEY_APP_GUIDE_UPDATE = @"MSG_APP_GUIDE_UPDATE";//欢迎和引导内容
static NSString * const MSG_KEY_GET_SPACE_MANAGER_RIGHT = @"MSG_GET_SPACE_MANAGER_RIGHT";//被添加为世界管理员
static NSString * const MSG_KEY_LOST_SPACE_MANAGER_RIGHT = @"MSG_LOST_SPACE_MANAGER_RIGHT";//不再是世界管理员
static NSString * const MSG_KEY_WORLDVIEW_ = @"MSG_WORLDVIEW_";//待审核的新人物
static NSString * const MSG_KEY_NEW_MODEL_EXAMINE = @"MSG_NEW_MODEL_EXAMINE";//新人物审核通过
static NSString * const MSG_KEY_ACCOUT_BE_UPDATE = @"MSG_ACCOUT_BE_UPDATE";//账号绑定信息修改
static NSString * const MSG_KEY_GLOBLE_NOTICE = @"MSG_GLOBLE_NOTICE";//官方手工发布通知

@interface NotificationHandler : NSObject


+ (void) handlerNotificationWithCustom:(NSDictionary *)customDic;

@end
