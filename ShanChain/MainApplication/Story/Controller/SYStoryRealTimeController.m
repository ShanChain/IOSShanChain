//
//  SYStoryRealTimeController.m
//  ShanChain
//
//  Created by krew on 2017/8/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRealTimeController.h"

@implementation SYStoryRealTimeController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestURL = RECOMMEND_HOT_LIST;
    }
    return self;
}

@end
