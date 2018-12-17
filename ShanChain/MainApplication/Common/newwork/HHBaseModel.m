//
//  HHBaseModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/9/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "HHBaseModel.h"

@implementation HHBaseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"code" : @"code",
             @"data" : @"data",
             @"message" : @[@"message",@"msg"]};
}


@end
