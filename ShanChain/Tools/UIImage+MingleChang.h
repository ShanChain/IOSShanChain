//
//  UIImage+MingleChang.h
//  MingleChang
//
//  Created by 常峻玮 on 16/3/27.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MC_Extension)


/** 设置圆形图片(放到分类中使用) */
- (UIImage *)cutCircleImage;


/**
*  将image的缩小或者放大到size，不产生虚边和锯齿
*
*  @param size CGSize，image设置后的尺寸大小
*
*  @return UIImage，设置之后得到的UIImage对象
*/
-(UIImage *)mc_resetToSize:(CGSize)size;

/**
 *  将image的透明度设置为alpha
 *
 *  @param alpha CGFloat，image设置的透明度
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage *)mc_resetToAlpha:(CGFloat)alpha;

/**
 *  将image进行缩放，宽度缩放比例为scaleW，高度缩放比例为scaleH
 *
 *  @param scaleW CGFloat，image宽度缩放比例
 *  @param scaleH CGFloat，image高度缩放比例
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage *)mc_resetToScaleWidth:(CGFloat)scaleW andScaleHeight:(CGFloat)scaleH;

/**
 *  将image进行宽度和高度的同比例缩放
 *
 *  @param scale CGFloat，image缩放比例
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage *)mc_resetToScale:(CGFloat)scale;

/**
 *  将image进行宽度缩放
 *
 *  @param scaleW CGFloat，image宽度缩放比例
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage *)mc_resetToScaleWidth:(CGFloat)scaleW;

/**
 *  将image进行高度缩放
 *
 *  @param scaleH CGFloat，image高度缩放比例
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage *)mc_resetToScaleHeight:(CGFloat)scaleH;

/**
 *  为image的纹理区域设置颜色
 *
 *  @param color UIColor，为image设置的颜色
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage *)mc_resetWithColor:(UIColor *)color;

/**
 *  为image的设置遮罩
 *
 *  @param mask UIImage，为image设置的遮罩
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage*)mc_resetWithMask:(UIImage*)mask;

/**
 *  将image的纹理设置到区域rect，但image的尺寸不变，其他区域为透明
 *
 *  @param rect CGRect，为image纹理设置的新的frame
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage*)mc_resetToRect:(CGRect)rect;

/**
 *  将image的纹理偏移，但image的尺寸不变，其他区域为透明
 *
 *  @param offset CGPoint，为image纹理设置偏移量
 *
 *  @return UIImage，设置之后得到的UIImage对象
 */
-(UIImage*)mc_resetToOffset:(CGPoint)offset;

/**
 *  裁剪image，根据裁剪区域rect得到新的图片
 *
 *  @param rect CGRect，裁剪区域
 *
 *  @return UIImage，将裁剪区域的纹理返回的UIImage对象
 */
- (UIImage *)mc_clipInRect:(CGRect)rect;

/**
 *  对image做灰阶处理
 *
 *  @return UIImage，灰阶处理后的UIImage对象
 */
-(UIImage *)mc_grayImage;

-(NSData *)mc_archiverMaxSize:(NSInteger)maxSize;
/**
 *  动态发布图片压缩
 *
 *  @param source_image 原图image
 *  @param maxSize      限定的图片大小
 *
 *  @return 返回处理后的图片
 */
- (NSData *)mc_resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;
@end
/**
 *  为UIImage添加高斯模糊效果
 */
@interface UIImage (MC_ImageEffects)

- (UIImage *)mc_applyLightEffect;
- (UIImage *)mc_applyExtraLightEffect;
- (UIImage *)mc_applyDarkEffect;
- (UIImage *)mc_applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)mc_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
