//
//  SYContactsController.h
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SYContactsTappedCallBack) (NSArray *contentArray);

@interface SYContactsController : SCBaseViewController

/*
 type
 0   处理方式为聊天
 1   单选返回
 2   多选返回
 */
@property (assign, nonatomic) int type;

@property (copy, nonatomic) SYContactsTappedCallBack callback;

@end
