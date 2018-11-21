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

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation HHTool

+ (YYHud *)showSucess:(NSString *)msg{
    return  [YYHud showSucess:msg];
}

+ (YYHud *)showError:(NSString *)msg{
    return  [YYHud showError:msg];
}

+ (void)dismiss {
    [[YYHud sharedInstance] dismiss];
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




@end
