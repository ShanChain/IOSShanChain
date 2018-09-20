//
//  SYMessageController.h
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "EaseConversationListViewController.h"
typedef NS_ENUM(NSInteger, SYMessageType) {
    SYMessageTypeNormal = 0,    // 闲聊
    SYMessageTypeDrama,     // 对戏
    SYMessageTypeNotice,    // 公告
    SYMessageTypeSence      // 情景
};

@interface SYMessageController : EaseMessageViewController

@property (copy, nonatomic) NSString *groupImg;

@end
