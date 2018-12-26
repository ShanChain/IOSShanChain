//
//  NewYearActivitiesView.h
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewYearActiveRushModel.h"

@interface NewYearActivitiesView : UIView

@property (weak, nonatomic) IBOutlet UILabel *laveNumberLb;


@property (weak, nonatomic) IBOutlet UILabel *countdownLb;

@property (weak, nonatomic) IBOutlet UILabel *addMoneyLb;

@property (weak, nonatomic) IBOutlet UILabel *allMoneyLb;

@property (weak, nonatomic) IBOutlet UILabel *levelNumberLb;

- (instancetype)initWithFrame:(CGRect)frame activeEndInterval:(NSTimeInterval)endInterval;

- (void)setActiveRushModel:(NewYearActiveRushModel *)rushModel;

@property  (nonatomic,copy)  void (^activeEndBlock)();

@end
