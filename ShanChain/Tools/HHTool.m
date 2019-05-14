//
//  HHTool.m
//  ShanChain
//
//  Created by 千千世界 on 2018/10/8.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "HHTool.h"
#import <objc/message.h>

#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"



@implementation HHTool

+ (YYHud *)showTip:(NSString *)msg duration:(NSTimeInterval)duration {
  
    return [[YYHud sharedInstance] showTip:msg duration:duration];
}

+ (YYHud *)showSucess:(NSString *)msg{
    return  [YYHud showSucess:msg];
}

+ (YYHud *)showError:(NSString *)msg{
    return  [YYHud showError:msg];
}

+ (void)dismiss {
    [[YYHud sharedInstance] dismiss];
}

+ (void)immediatelyDismiss {
    [[YYHud sharedInstance] immediatelyDismiss];
}


+ (YYHud *)show:(NSString *)msg {
    return [[YYHud sharedInstance] show:msg];
}

+ (YYHud *)showChrysanthemum{
    return [[YYHud sharedInstance] show:@""];
}

+ (YYHud *)showResponseObject:(NSDictionary *)response{
    if (!response) {
        return nil;
    }
    NSString  *msg = response[@"message"];
    if NULLString(msg) return nil;
    return  [YYHud showSucess:msg];
}

+ (id)getControllerResponsder:(UIView*)view{
    id  object = [view nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object!= nil) {
        object = [object nextResponder];
    }
    return object;
}

+(void)openAppStore{
    NSString * url = [NSString stringWithFormat:@"itms://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",AppStoreID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}


// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    if ([window subviews].count == 0) {
        return window.rootViewController;
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

+ (UIViewController *)getCurrentVC1
{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    //1、tabBarController
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //或者 UINavigationController * nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        //2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}
#pragma mark -- 获取当前语言
+ (NSString*)getPreferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    
    return preferredLang;
    
}

+(UIImage*)getHeadImageWithSize:(CGSize)size{
    
    if ([SCCacheTool shareInstance].headImage) {
        return [SCCacheTool shareInstance].headImage;
    }
    
    NSString  *headImg = [SCCacheTool shareInstance].characterModel.characterInfo.headImg;
    if (NULLString(headImg)) {
        return [UIImage imageNamed:@"com_icon_user_80"];
    }
    UIImage *headImage = [UIImage imageFromURLString:headImg];
    headImage = [headImage mc_resetToSize:size];
    headImage = [headImage cutCircleImage];
    [SCCacheTool shareInstance].headImage = headImage;
    return headImage;
}

//获取设备当前网络IP地址
+(NSString *)getDeviceIPIpAddresses{
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE =4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len =sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
                
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;                        if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;                        memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;                                                NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
            
        }
        
    }
    close(sockfd);
    NSString *deviceIP =@"";
    for (int i=0; i < ips.count; i++)
    {
        if (ips.count >0)                    {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
        }
        
    }
    NSLog(@"deviceIP========%@",deviceIP);    return deviceIP;    }


+ (BOOL)_IS_IPHONE_5{
    return IS_IPHONE_5;
}

+ (BOOL)_IS_IPHONE_6{
    return IS_IPHONE_6;
}

+ (BOOL)_IS_IPHONE_6P{
    return IS_IPHONE_6P;
}

+ (BOOL)_IS_IPHONE_X{
    return IS_IPHONE_X;
}



//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


+ (UIWindow *)mainWindow{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    }else{
        return  [app keyWindow];
    }
}


// 获取视频第一帧
+ (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

+ (NSDictionary *)getVideoInfoWithSourcePath:(NSURL *)path{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithContentsOfURL:path usedEncoding:NSUTF8StringEncoding error:nil]error:nil].fileSize;
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}

+ (UIViewController*)storyBoardWithName:(NSString*)name Identifier:(NSString*)identifier{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:identifier ?:name];
}


// 检查相机访问权限
+(BOOL)checkCameraPermission{
    
    BOOL isAvalible = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
      
        //提示用户开启相册权限
        [[HHTool getCurrentVC]sc_hrShowAlertWithTitle:@"温馨提示" message:@"检测到手机系统已关闭读取相机权限，请前往【设置】-【隐私】-【相机】中开启" buttonsTitles:@[@"我知道了"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
            
        }];
        
    } else {
        isAvalible = YES;
    }
    return isAvalible;
}

// 检查相册访问权限
+(BOOL)checkDetectionPhotoPermission:(void(^)(void))authorizedBlock
{
    BOOL isAvalible = NO;
    
    if (iOS8x_systemVersion)
    {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        //用户尚未授权
        if (authStatus == PHAuthorizationStatusNotDetermined)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized)
                {
                    if (authorizedBlock)
                    {
                        authorizedBlock();
                    }
              }}];
        }
        //用户已经授权
        else if (authStatus == PHAuthorizationStatusAuthorized)
        {
            isAvalible = YES;
            
            if (authorizedBlock)
            {
                authorizedBlock();
            }
        }
        //用户拒绝授权
        else
        {
            //提示用户开启相册权限
            [[HHTool getCurrentVC]sc_hrShowAlertWithTitle:@"温馨提示" message:@"检测到手机系统已关闭读取相册权限，请前往【设置】-【隐私】-【照片】中开启" buttonsTitles:@[@"我知道了"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
                
            }];
        }
    }
    else
    {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        
        //用户已经授权
        if (authStatus == ALAuthorizationStatusAuthorized)
        {
            isAvalible = YES;
            
            if (authorizedBlock)
            {
                authorizedBlock();
            }
        }
        //用户拒绝授权
        else
        {
            //提示用户开启相册权限
            [[HHTool getCurrentVC]sc_hrShowAlertWithTitle:@"温馨提示" message:@"检测到手机系统已关闭读取相册权限，请前往【设置】-【隐私】-【照片】中开启" buttonsTitles:@[@"我知道了"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
                
            }];
        }
    }
    
    return isAvalible;
    
}

+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}
@end
