//
//  SCDatePickerMd.m
//  ShanChain
//
//  Created by krew on 2017/11/2.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCDatePickerMd.h"
#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>
#import "SCAppManager.h"

#import "ApprDataPickeryMd.h"
#import "SYBigDramaController.h"
#import "SCDatePicker.h"

@interface SCDatePickerMd()


@property(nonatomic,strong) SCDatePicker *datePicker;
@end

@implementation SCDatePickerMd


RCT_EXPORT_MODULE(SCDatePickerMdMention);

RCT_EXPORT_METHOD(showDatePicker:(RCTResponseSenderBlock)successCallback errorCallBack  : (RCTResponseErrorBlock)errorCallBack){
       dispatch_sync(dispatch_get_main_queue(), ^{
    _datePicker = [[SCDatePicker alloc] init];
           NSDate *now = [NSDate date];
           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
           [formatter setDateFormat:@"YYYY-MM-dd"];
           NSString *currentTimeString = [formatter stringFromDate:now];
           [_datePicker showDatePicker:currentTimeString success:^(id value){
               successCallback(@[value]);
           } error:^(id err){
               errorCallBack(@[err]);
           }];
       });
}



@end
