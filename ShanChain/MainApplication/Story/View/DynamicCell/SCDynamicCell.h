//
//  SCDynamicCell.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/22.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDynamicStatusFrame;
@class SCDynamicDetailView;
@class SCDynamicChainView;

@protocol SCDynamicCellDelegate <NSObject>

- (void)dynamicCellTapButtonCommentWithIndexPath:(NSIndexPath *)indexPath;

- (void)dynamicCellTapButtonSupportWithIndexPath:(NSIndexPath *)indexPath withSupported:(BOOL)isSupported;

- (void)dynamicCellTapButtonShareWithIndexPath:(NSIndexPath *)indexPath;

- (void)dynamicCellTapButtonExpandWithIndexPath:(NSIndexPath *)indexPath;
// 头像点击
- (void)dynamicCellTapButtonIconWithIndexPath:(NSIndexPath *)indexPath;
// 点击转发第几楼
- (void)dynamicCellTapChainCellWithIndexPath:(NSIndexPath *)indexPath withIndex:(int)index;

@end

@interface SCDynamicCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) SCDynamicStatusFrame *dynamicStatusFrame;

@property (strong, nonatomic) SCDynamicDetailView *dynamicDetailView;

@property (strong, nonatomic) SCDynamicChainView *dynamicChainView;

@property (strong, nonatomic) id<SCDynamicCellDelegate> delegate;

@end
