//
//  NewYearActiveRushModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "NewYearActiveRushModel.h"

@implementation NewYearActiveRushModel

@end


@implementation RushModel

- (NSString *)reward{
    if (!_reward) {
        return @"0.00";
    }
    return _reward;
}

- (NSString *)levelName{
    if (self.level.integerValue == 1) {
        return @"一";
    }else if (self.level.integerValue == 2){
        return @"二";
    }else if (self.level.integerValue == 3){
        return @"三";
    }
    return @"四";
}

@end






