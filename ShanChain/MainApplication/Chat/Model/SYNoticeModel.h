//
//  SYNoticeModel.h
//  ShanChain
//
//  Created by krew on 2017/10/17.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYNoticeModel : NSObject

@property (nonatomic, assign) long long   createTime;

@property(nonatomic,copy)NSString *groupId;

@property(nonatomic,copy)NSString *notice;

@property(nonatomic,copy)NSString *title;

@property (nonatomic, assign) long   id;

@end
