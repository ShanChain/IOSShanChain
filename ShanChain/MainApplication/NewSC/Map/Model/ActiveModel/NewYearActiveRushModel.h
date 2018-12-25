//
//  NewYearActiveRushModel.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/25.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RushModel;

@interface NewYearActiveRushModel : NSObject

@property   (nonatomic,copy) NSString  *userId;
@property   (nonatomic,copy) NSString  *charaterId;
@property   (nonatomic,strong)   RushModel  *rushActivityVo;


@end


@interface RushModel : NSObject


@property   (nonatomic,strong) NSNumber  *endTime;
@property   (nonatomic,strong) NSNumber  *level;
@property   (nonatomic,copy) NSString  *surplusCount;
@property   (nonatomic,copy) NSString  *totalAmount;
@property   (nonatomic,copy) NSString  *reward;
@property   (nonatomic,strong) NSNumber  *presentTime;
@property   (nonatomic,assign) BOOL       clearance; // 是否通关


@end
