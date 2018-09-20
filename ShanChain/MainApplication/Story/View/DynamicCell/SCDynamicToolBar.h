//
//  SCDynamicToolBar.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDynamicStatusFrame;

@protocol SCDynamicToolBarDelegate <NSObject>

- (void)toolbarButtonSupportWith:(BOOL)isSupport;

- (void)toolbarButtonComment;

- (void)toolbarButtonShare;

@end

@interface SCDynamicToolBar : UIView

@property (strong, nonatomic) id<SCDynamicToolBarDelegate> delegate;

- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame;

@end
