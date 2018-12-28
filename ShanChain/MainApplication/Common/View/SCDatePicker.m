//
//  SCDatePicker.m
//  ShanChain
//
//  Created by flyye on 2017/12/14.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDatePicker.h"
#import <Foundation/Foundation.h>
#import "SCAppManager.h"

#import "ApprDataPickeryMd.h"


@interface SCDatePicker()<ApprDataPickeryMdDelegate>


@property (nonatomic, strong) ApprDataPickeryMd *datePicker;//显示 年月日
@property(nonatomic,copy) void(^succssBlock)(id value);
@property(nonatomic,copy) void(^failBlock)(id value);

@end

@implementation SCDatePicker

-(void)showDatePicker:(NSString *)initDate  success:(void (^)(id result))success error:(void (^)(id err))error{
        self.datePicker = [ApprDataPickeryMd new];
        self.datePicker.delegate = self;
        [self.datePicker open:initDate index:2];
    _succssBlock = success;
    _failBlock = error;
}

- (void)onSelectDateMd:(NSString *)date{
    
}

- (void)onCompletedBtnClicked:(NSString *)date{
    _succssBlock(date);
}

- (void)cancalBtnClicked{
}


@end
