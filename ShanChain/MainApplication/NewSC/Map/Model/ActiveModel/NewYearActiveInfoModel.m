//
//  NewYearActiveInfoModel.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "NewYearActiveInfoModel.h"

@implementation NewYearActiveInfoModel


-(NSTimeInterval)startTimeInterval{
    return self.startTime.integerValue/1000;
}

-(NSTimeInterval)endTimeInterval{
    return self.endTime.integerValue/1000;
}

@end






