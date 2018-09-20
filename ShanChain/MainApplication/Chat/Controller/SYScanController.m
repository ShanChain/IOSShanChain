//
//  SYScanController.m
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScanController.h"
#import "SYScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface SYScanController ()<SYScanViewDelegate>{
    int line_tag;
    UIView *highlightView;
    NSString *scanMessage;
    BOOL isRequesting;
}

@property (nonatomic,weak) SYScanView *scanV;

@end

@implementation SYScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描";
    
    SYScanView *scanV = [[SYScanView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scanV.delegate = self;
    scanV.backgroundColor = RGB(0, 0, 0);
    [self.view addSubview:scanV];
    _scanV = scanV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getScanDataString:(NSString*)scanDataString{
    
    SCLog(@"二维码内容：%@",scanDataString);
}


@end
