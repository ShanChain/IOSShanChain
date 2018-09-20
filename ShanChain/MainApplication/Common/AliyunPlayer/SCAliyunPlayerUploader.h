//
//  SCAliyunPlayerUploader.h
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/19.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadSVideoClient.h>

@protocol SCFileTransforProtocol<NSObject>

- (void)fileTransforProgressWithIdentity:(NSString *)indentity withProgress:(CGFloat)progress;

- (void)fileTransforSuccessWithIdentity:(NSString *)indentity;

- (void)fileTransforFailedWithIdentity:(NSString *)indentity withError:(NSError *)error;

@end

@interface SCAliyunPlayerUploader : NSObject

@property (strong, nonatomic) id<SCFileTransforProtocol> delegate;

+ (SCAliyunPlayerUploader *)sharedInstance;

- (void)uploadWithVideoPath:(NSString *)videoPath withImagePath:(NSString *)imagePath title:(NSString*)title desc:(NSString*)desc;

@end
