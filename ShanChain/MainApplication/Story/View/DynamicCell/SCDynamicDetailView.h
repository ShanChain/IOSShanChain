//
//  SCDynamicDetailView.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDynamicStatusFrame;

@interface SCDynamicDetailView : UIView
//头像
@property (nonatomic, strong) UIImageView *iconView;

- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame;

@end
