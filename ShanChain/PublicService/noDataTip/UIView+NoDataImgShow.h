//
//  UIView+NoDataImgShow.h
//  TYWithHHSProject
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 黄宏盛. All rights reserved.
//

#define TipImageDefault @"NoDataTipImage"
#import <UIKit/UIKit.h>


@interface UIView (NoDataImgShow)
- (NoDataTip *)noDataImgShow:(UIView *)superView  AndTheimage:(UIImage *)image;

@end


