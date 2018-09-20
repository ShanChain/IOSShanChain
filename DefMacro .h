//
//  DefMacro .h
//  ShanChain
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#ifndef DefMacro__h
#define DefMacro__h


//重写NSLog
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#define ViewRasterize(view)\
view.layer.shouldRasterize = YES;\
view.layer.rasterizationScale = [UIScreen mainScreen].scale;

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//弱引用
#define weakify(object) __weak __typeof__(object) weak##_##object = object;

//强引用
#define strongify(object) __typeof__(object) object = weak##_##object;

#endif /* DefMacro__h */
