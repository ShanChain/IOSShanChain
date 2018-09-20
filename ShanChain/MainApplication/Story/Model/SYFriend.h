//
//  SYFriend.h
//  ShanChain
//
//  Created by krew on 2017/10/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYFriend : NSObject

@property (nonatomic,copy)NSString   *headImg;

@property (nonatomic, assign) long  modelId;

@property (nonatomic,copy) NSString   *name;

@property (nonatomic, assign) BOOL  isSelected;

@end
