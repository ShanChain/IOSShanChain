//
//  SYStoryConcernController.m
//  ShanChain
//
//  Created by krew on 2017/8/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryConcernController.h"
#import "SCDynamicStatusFrame.h"

@implementation SYStoryConcernController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestURL = RECOMMEND_STORY_LIST_FOCUS;
    }
    return self;
}

- (NSArray *)dynamicFramesWithModels:(NSArray *)models {
    NSMutableArray *array=[NSMutableArray array];
    for(SCDynamicModel *model in models){
        SCDynamicStatusFrame *statusFrame = [[SCDynamicStatusFrame alloc]init];
        model.showToolBar = model.type != 3;
        model.showChain = NO;
        statusFrame.dynamicModel = model;
        [array addObject:statusFrame];
    }
    return array;
}

@end
