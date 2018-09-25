//
//  UIViewController+NoDataTip.m
//  MyLibs
//
//  Created by michael chen on 14/12/10.
//  Copyright (c) 2014年 huan. All rights reserved.
//

#import "UIViewController+NoDataTip.h"
#import "UIColor+Extention.h"
#import <objc/runtime.h>
#import "UIImage+GIF.h"

#define TipBgColor [UIColor colorWithWhite:1 alpha:1]
#define TipLabelDefault @"很抱歉，暂时没有数据，请稍候再试!"
#define TipButtonDefault @"重新加载"
#define TipImageDefault @"NoDataTipImage"
#define TipImageWidth 150
#define TipLabelInterval 10

#define NoDataTipTag -9876243

@interface NoDataTip ()

@end

@implementation NoDataTip

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tag = NoDataTipTag;
        self.backgroundColor = TipBgColor;
        self.tipLabelInterval = TipLabelInterval;
        [self setUpSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    //[super layoutSubviews];
    self.frame = self.superview.bounds;
  
    CGSize size = [_tipLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)];
    _tipLabel.center = self.center;
    _tipLabel.bounds = CGRectMake(0, 0,SCREEN_WIDTH, size.height);
    
    if (!self.tipLabel.superview) {
        _tipImage.center = CGPointMake(self.centerX, self.centerY);
        _tipImage.frame = self.frame;
        self.backgroundColor = Theme_ViewBackgroundColor;
    }else{
        _tipImage.center = CGPointMake(_tipLabel.center.x, _tipLabel.center.y-_tipLabelInterval-size.height/2-_tipImage.frame.size.height/2);
    }
    
    
    CGSize buttonSize = [_tipButton sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
    
    _tipButton.bounds = CGRectMake(0, 0,buttonSize.width+40, buttonSize.height);
    _tipButton.center = CGPointMake(_tipLabel.center.x, _tipLabel.center.y+_tipLabelInterval+5+size.height/2+_tipButton.frame.size.height/2);
}


-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor colorWithString:@"999999"];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.backgroundColor = [UIColor clearColor];
    }
    return _tipLabel;
}

- (void)setUpSubViews
{
   
   
    _tipImage = [[UIImageView alloc] init];
    if (_tipLabel.superview) {
        _tipImage.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        _tipImage.contentMode = UIViewContentModeScaleAspectFill;
        _tipImage.clipsToBounds = YES;
        [_tipImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    
    
    [self addSubview:_tipImage];
    
    _tipButton = [[UIButton alloc] init];
    _tipButton.layer.cornerRadius = 3;
    [_tipButton setTitleColor:[UIColor colorWithString:@"999999"] forState:UIControlStateNormal];
    _tipButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _tipButton.layer.borderColor = [[UIColor colorWithString:@"cccccc"] CGColor];
    _tipButton.layer.borderWidth = 0.6;
    
    [_tipButton addTarget:self action:@selector(clickTipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tipButton];
}

- (void)update:(NSString *)content image:(UIImage *)image shouldLoading:(BOOL)loading  buttonTitle:(NSString *)title buttonBlock:(void (^)())buttonBlock {
    
    
    if (loading) {
        [YYHud show:@""];
//        NSString *gifName = @"new_refreshAnimation";
//        UIImage *simage = [UIImage sd_animatedGIFNamed:gifName];
//        _tipImage.image = simage;
//        _tipImage.animationDuration = 1; //执行一次完整动画所需的时长
//        if ([UIScreen mainScreen].scale == 2.0)
//            gifName = @"refreshAnimation_2x";
//        else
//            gifName = @"refreshAnimation_3x";
        
       // simage = [simage sd_animatedImageByScalingAndCroppingToSize:CGSizeMake(80, 80)];

//        self.imageView.image = simage;
//        self.imageView.frame = CGRectMake(MarginLeft, 0, simage.size.width, simage.size.height);
//        self.imageView.animationDuration = 1; //执行一次完整动画所需的时长
        
        if (title) {
            [self.tipButton setTitle:title forState:UIControlStateNormal];
            self.tipButton.hidden = NO;
            self.clickButtonBlock = buttonBlock;
        } else {
        
            self.tipButton.hidden = YES;
        }
        _tipLabel.text = content == nil ? @"数据加载中..." : content;
        
    } else {
        
        NSString *tipTitle = title?title:TipButtonDefault;
        [self.tipButton setTitle:tipTitle forState:UIControlStateNormal];
        self.tipButton.hidden = NO;
        self.clickButtonBlock = buttonBlock;
    
            UIImage *imageTmp = image == nil ? [UIImage imageNamed:TipImageDefault] : image;
            _tipImage.image = imageTmp;
           _tipLabel.text = content == nil ? TipLabelDefault : content;

    }

    [_tipImage sizeToFit];
    [self setNeedsLayout];

}
- (void)update:(NSString *)content image:(UIImage *)image
{
    _tipButton.hidden = YES;
    if (content) {
        [self addSubview:_tipLabel];
        _tipLabel.text = content == nil ? TipLabelDefault : content;
    }
    UIImage *imageTmp = image == nil ? [UIImage imageNamed:TipImageDefault] : image;
    _tipImage.image = imageTmp;
    [_tipImage sizeToFit];
    [self setNeedsLayout];
}

- (void)setTipLabelInterval:(NSInteger)tipLabelInterval {
    _tipLabelInterval = tipLabelInterval;
    [self setNeedsLayout];
}

- (void)showInView:(UIView *)superView content:(NSString *)content image:(UIImage *)image
{
    UIView *view = [superView viewWithTag:NoDataTipTag];
    if (!view || ![view isKindOfClass:[NoDataTip class]]) {
        [superView addSubview:self];
        [self update:content image:image];
        return;
    }

    [self update:content image:image];
}

- (void)clickTipButton:(id)sender {
    if (self.clickButtonBlock) {
        self.clickButtonBlock();
    }
}


@end

#pragma mark - UIViewController (NoDataTip)
static char NoDataTipKey;
@implementation UIViewController (NoDataTip)

- (NoDataTip *)loadingTipShow:(NSString *)content inView:(UIView *)superView {

    return [self noDataTipShow:superView shouldLoading:YES content:content image:nil buttonTitle:nil buttonBlock:nil];

}

- (NoDataTip *)noDataTipShow
{
    return [self noDataTipShow:self.view content:nil image:nil];
}

- (NoDataTip *)noDataTipShow:(NSString *)content image:(UIImage *)image
{

    return [self noDataTipShow:self.view content:content image:image];
}

- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content image:(UIImage *)image backgroundColor:(UIColor *)color {

    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        view = [[NoDataTip alloc] init];
        objc_setAssociatedObject(self, &NoDataTipKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }
    if (color) {
        view.backgroundColor = color;
    }
    [view update:content image:image];
    return view;

}

- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content{
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        view = [[NoDataTip alloc]init];
        objc_setAssociatedObject(self, &NoDataTipKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }
    [view update:content image:[UIImage imageNamed:@"cry"]];
    return view;
}

- (NoDataTip *)noDataTipShow:(UIView *)superView content:(NSString *)content image:(UIImage *)image
{
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        view = [[NoDataTip alloc] init];
        objc_setAssociatedObject(self, &NoDataTipKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }
    [view update:content image:image];
    return view;
}

- (NoDataTip *)noDataTipShow:(UIView *)superView shouldLoading:(BOOL)loading content:(NSString *)content image:(UIImage *)image buttonTitle:(NSString *)title buttonBlock:(void (^)())buttonBlock {
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        view = [[NoDataTip alloc] init];
        view.backgroundColor = Theme_ViewBackgroundColor;
        objc_setAssociatedObject(self, &NoDataTipKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [superView addSubview:view];
    }

    [view update:content image:image shouldLoading:loading buttonTitle:title buttonBlock:buttonBlock];
    return view;
}

- (void)noDataTipDismiss
{
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
    if (!view) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
    });
    
    objc_setAssociatedObject(self, &NoDataTipKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)noDataTipDismissWithAccomplishedBlock:(void (^)())accomplishedBlock {
    
    NoDataTip *view = objc_getAssociatedObject(self, &NoDataTipKey);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (!view) {
//            return;
//        }
//        [view removeFromSuperview];
//        
//        objc_setAssociatedObject(self, &NoDataTipKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//        if (accomplishedBlock) {
//            accomplishedBlock();
//        }
//    });
    [UIView animateWithDuration:2 animations:^{
        if (!view) {
            return;
        }
        [view removeFromSuperview];
        
        objc_setAssociatedObject(self, &NoDataTipKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     
        
    } completion:^(BOOL finished) {
        if (accomplishedBlock) {
            accomplishedBlock();
        }
    }];
}
@end
