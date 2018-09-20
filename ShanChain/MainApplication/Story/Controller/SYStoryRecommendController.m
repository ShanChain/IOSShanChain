　//
//  SYStoryRecommendController.m
//  ShanChain
//
//  Created by krew on 2017/8/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRecommendController.h"

@implementation SYStoryRecommendController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestURL = RECOMMEND_STORY_LIST;
    }
    return self;
}

@end
