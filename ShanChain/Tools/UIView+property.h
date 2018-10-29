//
//  UIView+property.h
//  FlyPlusProject
//
//  Created by apple on 2017/3/16.
//  Copyright © 2017年 westAir. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ApplicationInfo.h"

@interface UIView (property)

@property  (nonatomic,strong)  NSObject     *model;
@property  (nonatomic,strong)  NSObject     *contentModel;
//@property  (nonatomic,assign)  PNFontStyle fontStyle;
@property  (nonatomic,strong)  NSString     *parameStr;


+ (instancetype)instanceWithView;
- (void)_setCornerRadius:(CGFloat)radius;
-(void)_setCornerRadiusCircle;
@end


@interface UIImage (color)

+ (UIImage *)callImageWithColor:(UIColor*)color;

@end
