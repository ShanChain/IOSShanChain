//
//  SYStoryContentController.h
//  ShanChain
//
//  Created by krew on 2017/9/1.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDynamicStatusFrame;
@interface SYStoryContentController : SCBaseVC

@property (strong, nonatomic) SCDynamicStatusFrame *dynamicStatusFrame;

@property (strong, nonatomic) NSString *detailId;

@property (nonatomic,copy)    NSString  *characterId; //角色ID

@property (assign, nonatomic) int type;

@end
