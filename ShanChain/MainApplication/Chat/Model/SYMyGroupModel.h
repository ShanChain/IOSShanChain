//
//  SYMyGroupModel.h
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMyGroupModel : NSObject

@property   (nonatomic, assign) long   long    createTime;

@property   (nonatomic,copy)    NSString   *groupDesc;

@property   (nonatomic,copy)    NSString       *groupId;

@property   (nonatomic,copy)    NSString       *groupName;

@property   (nonatomic,strong)  NSDictionary *groupOwner;


@end
