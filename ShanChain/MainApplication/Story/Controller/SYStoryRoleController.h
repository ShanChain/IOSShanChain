//
//  SYStoryRoleController.h
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYStoryRoleController : SCBaseViewController

@property (nonatomic, copy) NSString    *name;
@property (nonatomic,  copy) NSString    *intro;
@property (nonatomic, strong) NSString     *bgPic;
@property (nonatomic, strong) NSString     *slogan;
@property (nonatomic, assign) long      spaceId;

@property (nonatomic, strong) NSDictionary *dataDict;


@property (nonatomic, assign) BOOL isFavorite;

@end
