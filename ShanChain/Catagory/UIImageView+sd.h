//
//  UIImageView+sd.h
//  TYWithHHSProject
//
//  Created by Apple on 2018/5/10.
//  Copyright © 2018年 黄宏盛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (sd)

-(void)_sd_setImageWithURLString:(NSString*)urlString placeholderImage:(UIImage *)placeholder;

-(void)_sd_setImageWithURLString:(NSString*)urlString;
//防止网络加载的图片被拉伸变形
- (void)preventImageViewExtrudeDeformation;

@end
