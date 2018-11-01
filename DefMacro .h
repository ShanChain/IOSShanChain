//
//  DefMacro .h
//  ShanChain
//
//  Created by apple on 2018/8/23.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#ifndef DefMacro__h
#define DefMacro__h


#define AppStoreID  @"1296793048"
#define IP_ADDRESS  @"192.168.0.115"
#define BMKAPPKEY   @"Tn2qg4L9kQO4xoAYXCevnyXiMyjGGf68"

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


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


// 适配IPHONEx常用宏定义
#define IOS11  @available(iOS 11.0, *)
#define kApplicationStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height //状态栏的高度
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define IPHONE_NAVIGATIONBAR_HEIGHT  (IS_IPHONE_X ? 88 : 64)
#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      (IS_IPHONE_X ? 32 : 0)
#define IPHONE_TOOL_HEIGHT           (IS_IPHONE_X ? 82 : 50)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//强引用
#define strongify(object) __typeof__(object) object = weak##_##object;

// 系统字体快捷使用
#define Font(size) [UIFont systemFontOfSize:(size)]

// 数值转颜色(0, 0, 0)
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1)]

#define RGB_Hex(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

// 数值转颜色(0, 0, 0, 1) 加透明度
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 16进制转颜色(0x067AB5)
#define RGB_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//获取相机权限状态
#define CameraStatus [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]
#define CameraDenied ((CameraStatus == AVAuthorizationStatusRestricted)||(CameraStatus == AVAuthorizationStatusDenied))
#define CameraAllowed (!CameraDenyed)

/** 定位权限*/
#define LocationStatus [CLLocationManager authorizationStatus];
#define LocationAllowed ([CLLocationManager locationServicesEnabled] && !((status == kCLAuthorizationStatusDenied) || (status == kCLAuthorizationStatusRestricted)))
#define LocationDenied (!LocationAllowed)

/** 消息推送权限*/
#define PushClose (([[UIDevice currentDevice].systemVersion floatValue]>=8.0f)?(UIUserNotificationTypeNone == [[UIApplication sharedApplication] currentUserNotificationSettings].types):(UIRemoteNotificationTypeNone == [[UIApplication sharedApplication] enabledRemoteNotificationTypes]))
#define PushOpen (!PushClose)


//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject]

//获取沙盒Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject]


//获取通知中心
#define NotificationCenter [NSNotificationCenter defaultCenter]

//快速发通知
#define Post_Notify(_notificationName, _obj, _userInfoDictionary) [[NSNotificationCenter defaultCenter] postNotificationName: _notificationName object: _obj userInfo: _userInfoDictionary];

//添加观察者
#define Add_Observer(_notificationName, _observer, _observerSelector, _obj) [[NSNotificationCenter defaultCenter] addObserver:_observer selector:@selector(_observerSelector) name:_notificationName object: _obj];

//移除观察者
#define Remove_Observer(_observer) [[NSNotificationCenter defaultCenter] removeObserver: _observer];

#endif /* DefMacro__h */
