//
//  SCDynamicChainView.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCDynamicChainDelegate <NSObject>

// 点击展开剩余楼层
- (void)chainViewTapExpandChains;

- (void)chainViewTapChainCellWithIndex:(int)index;

@end

@class SCDynamicStatusFrame;

@interface SCDynamicChainView : UIView

@property (strong, nonatomic) id<SCDynamicChainDelegate> delegate;

- (void)setDynamicStatusFrame:(SCDynamicStatusFrame *)dynamicStatusFrame;

@end
