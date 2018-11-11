//
//  SCBaseViewController.m
//  ShanChain
//
//  Created by flyye on 2017/12/7.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCBaseViewController.h"

@implementation SCBaseViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"aaaaaaaaaaaaa ===== %@",NSStringFromClass([self class]));
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(224, 224, 224);
}


#ifdef DEBUG
//第一响应，默认是NO
-(BOOL)canBecomeFirstResponder {
    return YES;
}

//开始
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"motionBegan");
}

//结束
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"motionEnded");
        NSArray  *hostArr = @[@"95.169.24.11",@"test.qianqianshijie.com"];
        [self hrShowActionSheetWithTitles:hostArr actionHandler:^(NSInteger indexOfAction, NSString * _Nonnull title) {
            if (indexOfAction == 0) {
               
            }else{
             
            }
        }];
        
    }
}

//摇晃取消
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}
#else
//do sth.
#endif



@end
