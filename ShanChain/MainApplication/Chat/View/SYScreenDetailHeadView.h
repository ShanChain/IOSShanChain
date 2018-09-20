//
//  SYScreenDetailHeadView.h
//  ShanChain
//
//  Created by krew on 2017/9/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYScreenDetailHeadView;

@protocol SYScreenDetailHeadViewDelegate <NSObject>

- (void)screenDetailHeadViewNoticeBtnAction;
- (void)createScreenViewAction;

@end

@interface SYScreenDetailHeadView : UIView

@property(nonatomic,strong)id<SYScreenDetailHeadViewDelegate> delegate;

- (void)setTitle:(NSString *)title withDetail:(NSString *)detail;

//headImg
//hxUserName       
//name
- (void)updateMemberList:(NSArray *)array;

@end
