//
//  NewYearActiveInfoModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewYearActiveInfoModel : NSObject

@property   (nonatomic,strong)  NSNumber *endTime;
@property   (nonatomic,copy) NSString  *ruleDescribe;
@property   (nonatomic,strong)   NSNumber  *startTime;


@property   (nonatomic,assign)  NSTimeInterval endTimeInterval;
@property   (nonatomic,assign)  NSTimeInterval startTimeInterval;

@end
