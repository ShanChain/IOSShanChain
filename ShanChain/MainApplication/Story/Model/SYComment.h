//
//  SYComment.h
//  ShanChain
//
//  Created by krew on 2017/10/10.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYComment : NSObject

@property (assign, nonatomic) long  storyId;

@property (copy, nonatomic) NSString  *commentId;

@property (copy, nonatomic) NSString   *content;

@property (copy, nonatomic) NSString * createTime;

@property (assign, nonatomic) int   isAnon;

@property (assign, nonatomic) long  supportCount;

@property (copy, nonatomic) NSString  *mySupport;

@property (copy, nonatomic) NSString  *characterId;

@property (copy, nonatomic) NSDictionary *info;

@end
