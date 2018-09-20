//
//  SYComposeTrendModel.h
//  ShanChain
//
//  Created by krew on 2017/10/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYComposeTrendModel : NSObject

@property (copy, nonatomic) NSString *background;

@property (copy, nonatomic) NSString *title;

@property (assign, nonatomic) long  topicId;

@property (assign, nonatomic) BOOL isNotExist;

@end
