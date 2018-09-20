//
//  SCFileSessionManager.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/19.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCFileSessionManager.h"

static SCFileSessionManager *instance = nil;

@interface SCFileSessionManager()

@property (copy, nonatomic) NSString *documentDirectory;

@end
@implementation SCFileSessionManager

+ (NSString *)dirHome {
    return NSHomeDirectory();
}

+ (NSString *)dirDocument {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)dirLibrary {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];;
}

+ (NSString *)dirPreference {
    return [[self dirLibrary] stringByAppendingPathComponent:@"Preferences"];
}

+ (NSString *)dirCache {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)dirTemp {
    return NSTemporaryDirectory();
}

+ (NSString *)dirSCVideoUploadPath {
    // 演绎
    NSString *baseVideoUploadPath = [[self dirDocument] stringByAppendingPathComponent:@"play"];
    BOOL isDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:baseVideoUploadPath isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:baseVideoUploadPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return baseVideoUploadPath;
}

+ (NSString *)getVideoPathWithIdentity:(NSString *)identity {
    return [[[self dirSCVideoUploadPath] stringByAppendingPathComponent:identity] stringByAppendingString:@".mp4"];
}

+ (NSString *)getImagePathWithIdentity:(NSString *)identity {
    return [[[self dirSCVideoUploadPath] stringByAppendingPathComponent:identity] stringByAppendingString:@".png"];
}

@end
