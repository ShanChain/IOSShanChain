//
//  UIView+ZRSFrame.h
//  Button的edge运用
//
//  Created by macpro on 15/9/5.
//  Copyright (c) 2015年 ZRS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZRSFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic,assign) CGFloat bottom;



-(void)setMaxX:(CGFloat)maxX;
-(CGFloat)maxX;

-(void)setMaxY:(CGFloat)maxY;
-(CGFloat)maxY;

- (void)makeLayerWithRadius:(CGFloat)radius withBorderColor:(UIColor *)color withBorderWidth:(CGFloat)width;

@end
