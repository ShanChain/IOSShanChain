//
//  SCFileSessionManager.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/19.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFileSessionManager : NSObject

+ (SCFileSessionManager *)sharedInstance;

@property (copy, nonatomic) NSString *baseVideoUploadPath;

// 沙盒的主目录路径
+ (NSString *)dirHome;
// 沙盒中Documents的目录路径
+ (NSString *)dirDocument;
// 沙盒中Library的目录路径
+ (NSString *)dirLibrary;
// 沙盒中Libarary/Preferences的目录路径
+ (NSString *)dirPreference;
// 沙盒中Library/Caches的目录路径
+ (NSString *)dirCache;
// 沙盒中tmp的目录路径
+ (NSString *)dirTemp;

// 视频上传的基础路径
+ (NSString *)dirSCVideoUploadPath;


+ (NSString *)getVideoPathWithIdentity:(NSString *)identity;

+ (NSString *)getImagePathWithIdentity:(NSString *)identity;

@end
