//
//  SYStorySelectFriendController.h
//  ShanChain
//
//  Created by krew on 2017/8/31.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYStorySelectFriendController;

@protocol SYSelectFriendControllerDelegate <NSObject>
/**
 {
 headImg: "",
 modelId: "",
 name: ""
 }
 */
- (void)selectFriendWithArray:(NSArray *)array;

- (void)selectFriendWithOpenGroupChat:(NSString *)groupId withGroupName:(NSString *)name;

@end

typedef void (^SYSelectFriendCallBack) (NSArray *array);

@interface SYStorySelectFriendController : SCBaseVC

// 1 群内联系人。0 选择整个时空的联系人 2 for群聊
@property (nonatomic, assign) int  type;

@property (copy, nonatomic) NSString *groupId;

@property (copy, nonatomic) SYSelectFriendCallBack callback;

@property (nonatomic, strong) id<SYSelectFriendControllerDelegate>delegate;


@end
