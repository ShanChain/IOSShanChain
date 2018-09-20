//
//  SYWaterFlowLayout.h
//  ShanChain
//
//  Created by krew on 2017/8/25.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYWaterFlowLayout;

@protocol SYWaterFlowLayoutDelegate <NSObject>
@required

-(CGFloat )SYWaterFlowLayout:(SYWaterFlowLayout *)WaterFlowLayout heightForRowAtIndexPath :(NSInteger )index itemWidth :(CGFloat )itemWidth section :(NSInteger )section;

@optional

-(CGFloat )columnCountInWaterflowLayout :(SYWaterFlowLayout *)waterflowLayout section :(NSInteger )section;

- (CGFloat)columnMarginInWaterflowLayout:(SYWaterFlowLayout *)waterflowLayout;

- (CGFloat)rowMarginInWaterflowLayout:(SYWaterFlowLayout *)waterflowLayout;

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(SYWaterFlowLayout *)waterflowLayout;

@end

@interface SYWaterFlowLayout : UICollectionViewLayout

@property(nonatomic,weak)id<SYWaterFlowLayoutDelegate> delegate;

@end
