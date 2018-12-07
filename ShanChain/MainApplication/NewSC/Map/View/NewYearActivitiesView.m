//
//  NewYearActivitiesView.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/6.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "NewYearActivitiesView.h"



@implementation NewYearActivitiesView{
     dispatch_source_t _timer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self = [NewYearActivitiesView instanceWithView];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    MCDate  *deadlineDate = [MCDate dateWithInterval:1546099200];
    NSInteger secondsCountDown = deadlineDate.date.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970;
    __weak __typeof(self) weakSelf = self;
    if (_timer == nil) {
        __block NSInteger timeout = secondsCountDown; // 倒计时时间
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf removeFromSuperview];
                    });
                } else { // 倒计时重新计算 时/分/秒
                    NSInteger days = (int)(timeout/(3600*24));
                    NSInteger hours = (int)((timeout-days*24*3600)/3600);
                    NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                    NSString *strTime = [NSString stringWithFormat:@"活动倒计时 %02ld : %02ld : %02ld", hours, minute, second];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days == 0) {
                            weakSelf.countdownLb.text = strTime;
                        } else {
                            weakSelf.countdownLb.text = [NSString stringWithFormat:@"%ld天 %02ld : %02ld : %02ld", days, hours, minute, second];
                        }
                        
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                }
            });
            dispatch_resume(_timer);
        }
    }

}

@end
