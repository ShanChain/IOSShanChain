//
//  UIView+property.m
//  FlyPlusProject
//
//  Created by apple on 2017/3/16.
//  Copyright © 2017年 westAir. All rights reserved.
//

#import "UIView+property.h"
#import "objc/runtime.h"
#import "UIImage+GIF.h"

@implementation UIView (property)



-(void)setModel:(NSObject *)model{
    objc_setAssociatedObject(self, @selector(model), model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject *)model{
   return  objc_getAssociatedObject(self, _cmd);

}

-(void)setContentModel:(NSObject *)contentModel{

    objc_setAssociatedObject(self, @selector(contentMode), contentModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject *)contentModel{
    return  objc_getAssociatedObject(self, _cmd);
}

-(void)setParameStr:(NSString *)parameStr{
    objc_setAssociatedObject(self, @selector(parameStr), parameStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)parameStr{
  
    return objc_getAssociatedObject(self, _cmd);
}

//-(void)setFontStyle:(PNFontStyle)fontStyle{
//    objc_setAssociatedObject(self, @selector(fontStyle), @(fontStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    switch (fontStyle) {
//        case PNFontStyle_Main:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo MainTextStyle].color;
//                lb.font      = [ApplicationInfo MainTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo MainTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo MainTextStyle].font;
//            }
//            break;
//        case PNFontStyle_MainAssociated:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo MainAssociatedTextStyle].color;
//                lb.font      = [ApplicationInfo MainAssociatedTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo MainAssociatedTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo MainAssociatedTextStyle].font;
//            }
//            break;
//        case PNFontStyle_Associated:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo associatedTextStyle].color;
//                lb.font      = [ApplicationInfo associatedTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo associatedTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo associatedTextStyle].font;
//            }
//
//            break;
//        case PNFontStyle_White:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo whiteTextStyle].color;
//                lb.font      = [ApplicationInfo whiteTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo whiteTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo whiteTextStyle].font;
//            }
//
//
//            break;
//        case PNFontStyle_tip:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo tipTextStyle].color;
//                lb.font      = [ApplicationInfo tipTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo tipTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo tipTextStyle].font;
//            }
//            break;
//        case PNFontStyle_Orange:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo orangeTextStyle].color;
//                lb.font      = [ApplicationInfo orangeTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo orangeTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo orangeTextStyle].font;
//            }
//            break;
//        case PNFontStyle_Normal:
//            if ([self isKindOfClass:[UILabel class]]) {
//                UILabel *lb = (UILabel*)self;
//                lb.textColor = [ApplicationInfo normalTextStyle].color;
//                lb.font      = [ApplicationInfo normalTextStyle].font;
//            }else if ([self isKindOfClass:[UIButton class]]){
//                UIButton *btn = (UIButton*)self;
//                [btn setTitleColor:[ApplicationInfo normalTextStyle].color forState:0];
//                btn.titleLabel.font = [ApplicationInfo normalTextStyle].font;
//            }
//        default:
//            break;
//    }
//
//
//}


//-(PNFontStyle)fontStyle{
//    
//    return [objc_getAssociatedObject(self, _cmd)integerValue];;
//
//}

+(instancetype)instanceWithView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil]firstObject];
}

-(void)_setCornerRadius:(CGFloat)radius{
    if (radius == 10) {
        radius = 6;
    }
    ViewRadius(self, radius);
}

-(void)_setCornerRadiusCircle{
    ViewRadius(self, self.width/2.0);
}


-(void)preventImageViewExtrudeDeformation{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
}

-(void)alphaComponentMake{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.35];
}

@end


@implementation UIImage (color)

#pragma mark -- 颜色转图片
+ (UIImage *)callImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
