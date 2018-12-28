//
//  SCReportController.h
//  ShanChain
//
//  Created by krew on 2017/5/31.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCReportController : SCBaseVC

@property (nonatomic,copy)NSString *detailId;
@property (nonatomic,copy)NSString *userId; //当前要举报的用户id
@property (nonatomic,assign)   BOOL    isReportPersonal; //是否举报个人

@end
