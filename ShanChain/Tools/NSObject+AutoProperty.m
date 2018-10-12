//
//  NSObject+AutoProperty.m
//  NEWLTG
//
//  Created by 黄宏盛 on 16/3/28.
//  Copyright © 2016年 黄宏盛. All rights reserved.
//

#import "NSObject+AutoProperty.h"
#import <objc/message.h>


//#import "sys/utsname.h"
//#import <AdSupport/AdSupport.h>
//
//#import <ifaddrs.h>
//#import <arpa/inet.h>
//#import <sys/sockio.h>
//#import <sys/ioctl.h>
//
//#include <sys/socket.h> // Per msqr
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//
//#define IOS_CELLULAR    @"pdp_ip0"
//#define IOS_WIFI        @"en0"
////#define IOS_VPN       @"utun0"
//#define IP_ADDR_IPv4    @"ipv4"
//#define IP_ADDR_IPv6    @"ipv6"


@implementation NSObject (AutoProperty)

/**
 *  自动生成属性列表
 *
 *  @param dict JSON字典/模型字典
 */
+(void)printPropertyWithDict:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
#if DEBUG
    NSMutableString *allPropertyCode = [[NSMutableString alloc]init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *oneProperty = [[NSString alloc]init];
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNull class]] ) {
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy)   NSString *%@;",key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy)   NSString *%@;",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            NSArray  *objs = (NSArray*)obj;
            if (objs.count > 0) {
                NSDictionary  *dict = objs[0];
                [NSObject printPropertyWithDict:dict];
            }
            
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy)   NSArray *%@;",key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy)   NSDictionary *%@;",key];
        }else if ([obj isKindOfClass:[NSObject class]]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSObject  *%@;)",key];
        }
        [allPropertyCode appendFormat:@"%@\n",oneProperty];
    }];
    DLog(@"自动生成属性列表 === \n%@",allPropertyCode);
  //  NSLog(@"自动生成属性列表 === \n%@",allPropertyCode);
    #endif
}


-(void)autoPropertyPathForResource:(NSString*)name OfType:(NSString*)type KeyAry:(NSArray<NSString*>*)ary{
    NSDictionary *dict = [self pathForResource:name ofType:type];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic addEntriesFromDictionary:dict];
    if (ary && ary.count > 0) {
        for (NSString *key in ary) {
            if ([mutableDic.allKeys containsObject:key]) {
                if ([[mutableDic objectForKey:key] isKindOfClass:[NSArray class]]) {
                    mutableDic = [mutableDic objectForKey:key][0];
                }else{
                    mutableDic = [mutableDic objectForKey:key];
                }
                
            }
        }
    }
    
    [NSObject printPropertyWithDict:mutableDic];

}


-(void)appNetworkStatus:(void(^)(AFNetworkReachabilityStatus status))block{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BLOCK_EXEC(block,status);
    }];
    
}


-(void)judgmentAppNetworkWithStatusBar:(void (^)(AppNetworkReachabilityStatus))block{
    // 状态栏是由当前控制器控制的，首先获取当前app。
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children;
    // 遍历状态栏上的前景视图
    if ([[app valueForKeyPath:@"_statusBar"]isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        children = [[[[app valueForKeyPath:@"_statusBar"]valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }else{
        children = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    // type数字对应的网络状态依次是：0：无网络；1：2G网络；2：3G网络；3：4G网络；5：WIFI信号
    
    NSLog(@"type is '%d'.", type);
    
    BLOCK_EXEC(block,type);
    
}






- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [self init]) {
        //(1)获取类的属性及属性对应的类型
        NSMutableArray * keys = [NSMutableArray array];
        NSMutableArray * attributes = [NSMutableArray array];
        /*
         * 例子
         * name = value3 attribute = T@"NSString",C,N,V_value3
         * name = value4 attribute = T^i,N,V_value4
         */
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            //通过property_getAttributes函数可以获得属性的名字和@encode编码
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        //立即释放properties指向的内存
        free(properties);
        
        //(2)根据类型给属性赋值
        for (NSString * key in keys) {
            if ([dict valueForKey:key] == nil) continue;
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
    return self;
    
}


-(id)getArchiverPathComponent:(NSString*)component rootObject:(id)objc
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:component];
    if (objc) {
        //当对象不为nil进行归档解档操作
        BOOL success = [NSKeyedArchiver archiveRootObject:objc toFile:path];
        objc = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (success && objc) {
            //成功后返回
            return objc;
        }
        
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
}

// JSON解析

-(id)pathForResource:(NSString*)resource ofType:(NSString*)type
{
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:resource ofType:type];
    NSData *data  = [NSData dataWithContentsOfFile:path];
    if (data) {
        id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        return dic;
    }
    
    return nil;
    
    
}

- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
    //得到两个数组中不同的数据
    NSArray * reslutFilteredArray = [arr2 filteredArrayUsingPredicate:filterPredicate];
    if (reslutFilteredArray.count > 0) {
        return YES;
    }
    return NO;
}

- (NSArray*)loadLocalJsonFilesName:(NSString*)fileName{
    NSString *itemPath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"geojson"];
    return [[NSData dataWithContentsOfFile:itemPath] mj_JSONObject];
}

//获取设备当前网络IP地址
//- (NSString *)getIPAddress:(BOOL)preferIPv4
//{
//    NSArray *searchArray = preferIPv4 ?
//    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
//    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
//    
//    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
//    
//    __block NSString *address;
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//     {
//         address = addresses[key];
//         if(address) *stop = YES;
//     } ];
//    return address ? address : @"0.0.0.0";
//}
//
//
////获取所有相关IP信息
//- (NSDictionary *)getIPAddresses
//{
//    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
//    
//    // retrieve the current interfaces - returns 0 on success
//    struct ifaddrs *interfaces;
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        struct ifaddrs *interface;
//        for(interface=interfaces; interface; interface=interface->ifa_next) {
//            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
//                continue; // deeply nested code harder to read
//            }
//            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
//            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                NSString *type;
//                if(addr->sin_family == AF_INET) {
//                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv4;
//                    }
//                } else {
//                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
//                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv6;
//                    }
//                }
//                if(type) {
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                    
//                }
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    return [addresses count] ? addresses : nil;
//}
//
//- (NSString *)macAddress
//{
//    
//    int                 mib[6];
//    size_t              len;
//    char                *buf;
//    unsigned char       *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl  *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1/n");
//        return NULL;
//    }
//    
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        return NULL;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    
//    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    
//    NSLog(@"outString:%@", outstring);
//    
//    free(buf);
//    
//    return [outstring uppercaseString];
//}

@end
