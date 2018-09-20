//
//  ApprDataPickeryMd.m
//  smartapc-ios
//
//  Created by 张小杨 on 16/11/25.
//  Copyright © 2016年 list. All rights reserved.
//

#import "ApprDataPickeryMd.h"

@interface ApprDataPickeryMd ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView            *wrapView;
@property (nonatomic, strong) NSMutableArray    *yearArray;
@property (nonatomic, strong) UIDatePicker      *datePickeryMd;
@property (nonatomic,strong)UIView               *popView;

@end

@implementation ApprDataPickeryMd

- (UIDatePicker *)datePickeryMd {
    if (!_datePickeryMd) {
        _datePickeryMd = [UIDatePicker new];
        _datePickeryMd.backgroundColor = [UIColor whiteColor];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePickeryMd.locale = locale;
        _datePickeryMd.datePickerMode = UIDatePickerModeDate;
        _datePickeryMd.date = [NSDate date];
        NSDate *currentDate = [NSDate date];
        _datePickeryMd.maximumDate = currentDate;
    }
    return _datePickeryMd;
}

- (void)make {
    UIView *wrapView = [UIView new];
    wrapView.backgroundColor = RGBA(0, 0, 0, 0.5);
    wrapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[AppDelegate sharedInstance].window addSubview:wrapView];
    self.wrapView = wrapView;
    
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
    myTapGesture.delegate = self;
    [myTapGesture setNumberOfTapsRequired:1];
    self.wrapView.userInteractionEnabled = YES;
    [self.wrapView addGestureRecognizer:myTapGesture];
    
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -(300.0/667 *SCREEN_HEIGHT), SCREEN_WIDTH, (300.0/667)*SCREEN_HEIGHT)];
    popView.backgroundColor = [UIColor whiteColor];
    self.popView = popView;
    [self.wrapView addSubview:popView];
    
    [popView addSubview:self.datePickeryMd];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(KSCMargin, 10, 40, 17);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearBtn setTitleColor:RGB(0, 118, 255) forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [wrapView addSubview:clearBtn];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(SCREEN_WIDTH -40-KSCMargin, 10, 40, 17);
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [completeBtn setTitleColor:RGB(0, 118, 255) forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [wrapView addSubview:completeBtn];
    
    [popView addSubview:clearBtn];
    [popView addSubview:completeBtn];
    
    self.datePickeryMd.frame = CGRectMake(0, 60.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 216.0/667*SCREEN_HEIGHT);
    [self.datePickeryMd addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.wrapView.hidden = YES;
}

- (void)dateChanged:(UIDatePicker *)picker {
    NSDate *select  = [picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    //LOG(@"选择的日期:%@",dateAndTime);
    self.endDateString = dateAndTime;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectDateMd:)]) {
        [self.delegate onSelectDateMd:dateAndTime];
    }
}

- (void)gestureTapEvent:(UIGestureRecognizer *)gestureRecognizer {
    [self close];
}

-(void)clearAction {
    [self close];
}

-(void)completeAction{
    if(self.endDateString){
        if (_delegate && [_delegate respondsToSelector:@selector(onCompletedBtnClicked:)]) {
            [_delegate onCompletedBtnClicked:self.endDateString];
        }
        [self close];
    }
}

//打开
- (void)open:(NSString *)strDate  index:(int)index{
    [self make];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.endDateString = dateString;
    if (date) {
        self.datePickeryMd.date = date;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectDateMd:)]) {
        [self.delegate onSelectDateMd:strDate];
    }
    WS(weakSelf);
    [Util commonViewAnimation:^{
        weakSelf.wrapView.hidden = NO;
        weakSelf.datePickeryMd.frame = CGRectMake(0, 60.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 216.0/667*SCREEN_HEIGHT);
        
    } completion:^{
    }];
}
//关闭
- (void)close {
    WS(weakSelf);
    [Util commonViewAnimation:^{
        weakSelf.wrapView.hidden = NO;
        weakSelf.datePickeryMd.frame = CGRectMake(0, 60.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 216.0/667*SCREEN_HEIGHT);
    } completion:^{
        weakSelf.wrapView.hidden = YES;
        [weakSelf.wrapView removeFromSuperview];
    }];
}

@end
