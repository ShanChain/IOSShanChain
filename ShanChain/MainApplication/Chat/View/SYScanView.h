//
//  SYScanView.h
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYScanViewDelegate <NSObject>

-(void)getScanDataString:(NSString*)scanDataString;

@end

@interface SYScanView : UIView

@property(nonatomic,strong)id <SYScanViewDelegate> delegate;
@property (nonatomic, assign) int    scanW;//扫描框的宽

- (void)startRunning;//开始扫描
- (void)stopRunning;//停止扫描

@end
