//
//  NSObject+AutoProperty.h
//  NEWLTG
//
//  Created by 黄宏盛 on 16/3/28.
//  Copyright © 2016年 黄宏盛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppNetworkReachabilityStatus) {
    AppNetworkReachabilityStatusNotReachable     = 0,
    AppNetworkReachabilityStatusReachable_2G     = 1,
    AppNetworkReachabilityStatusReachable_3G     = 2,
    AppNetworkReachabilityStatusReachable_4G     = 3,
    AppNetworkReachabilityStatusReachableViaWiFi = 5,
};


@interface NSObject (AutoProperty)


@property  (nonatomic,strong)  NSString     *mark; //唯一标记

//字典转模型
+(void)printPropertyWithDict:(NSDictionary *)dict;

//判断当前网络状态
-(void)appNetworkStatus:(void(^)(AFNetworkReachabilityStatus status))block;
-(void)judgmentAppNetworkWithStatusBar:(void(^)(AppNetworkReachabilityStatus status))block;

//rumtime字典转模型
- (instancetype)initWithDict:(NSDictionary *)dict;
//对模型进行归档操作
-(id)getArchiverPathComponent:(NSString*)component rootObject:(id)objc;

-(id)pathForResource:(NSString*)resource ofType:(NSString*)type;

//自动生成属性
-(void)autoPropertyPathForResource:(NSString*)name OfType:(NSString*)type KeyAry:(NSArray<NSString*>*)ary;
//比较两个数组数据是否相同
- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2;
//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4;
//获取当前的mac地址
- (NSString *)macAddress;
// 加载本地json文件
- (NSArray*)loadLocalJsonFilesName:(NSString*)fileName;
@end
