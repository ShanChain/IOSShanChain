//
//  SYMessageToolBar.h
//  ShanChain
//
//  Created by krew on 2017/9/12.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    SYMessageToolBarButtonTypeDrama,//大戏
    SYMessageToolBarButtonTypeScreen,//场景
    SYMessageToolBarButtonTypeMention,//艾特
    SYMessageToolBarButtonTypeAlert,//弹框
    
}SYMessageToolBarButtonType;

@class SYMessageToolBar;

@protocol SYMessageToolBarDelegate <NSObject>

- (void)messageCenter:(SYMessageToolBar *)toolbar didClickedButton:(SYMessageToolBarButtonType)buttonType;

- (void)composeToolSwitchBtn:(BOOL )isButtonOn;

@end

@interface SYMessageToolBar : UIView

@property (strong, nonatomic) id<SYMessageToolBarDelegate> delegate;

@property (assign, nonatomic) BOOL isGroup;

@end
