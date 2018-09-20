//
//  SYMarkModel.h
//  ShanChain
//
//  Created by krew on 2017/8/25.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMarkModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *intro;
@property (strong, nonatomic) NSString *background;
@property (strong, nonatomic) NSString *slogan;
@property (assign, nonatomic) long spaceId;
@property (assign, nonatomic) long favoriteNum;

@end
