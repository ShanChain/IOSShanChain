//
//  UIView+NoDataImgShow.m
//  TYWithHHSProject
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 黄宏盛. All rights reserved.
//

#import "UIView+NoDataImgShow.h"
static char NoDataTipKey;
@implementation UIView (NoDataImgShow)
- (void)updateimage:(UIImage *)image
{
    UIImage *imageTmp = image == nil ? [UIImage imageNamed:TipImageDefault] : image;
    
    UIImageView *theTempImg = [[UIImageView alloc] init];
    theTempImg.contentMode = UIViewContentModeTop;
    theTempImg.clipsToBounds = YES;
//    [theTempImg setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [theTempImg setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [self addSubview:theTempImg];
    theTempImg.image = imageTmp;
    [theTempImg sizeToFit];
    [self setNeedsLayout];
}
- (NoDataTip *)noDataImgShow:(UIView *)superView  AndTheimage:(UIImage *)image
{
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        view = [[NoDataTip alloc] init];
        objc_setAssociatedObject(self, &NoDataTipKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }
    [view updateimage:image];
    return view;
}

@end
