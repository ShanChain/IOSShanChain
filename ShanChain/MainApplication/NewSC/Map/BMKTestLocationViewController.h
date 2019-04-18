//
//  BMKTestLocationViewController.h
//  ShanChain
//
//  Created by 千千世界 on 2018/10/16.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "SCBaseVC.h"

@interface BMKTestLocationViewController : SCBaseVC
/// 是否是添加聊天室
@property (nonatomic,assign) BOOL isAddChatRoom;

///
@property (nonatomic,copy) void (^addChatRoomBlock)(void);
@end
