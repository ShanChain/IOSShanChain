//
//  SCAliyunUploadMananger.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/11/30.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCAliyunUploadMananger.h"
#import "SCNetworkError.h"

@interface SCAliyunUploadMananger ()

@property  (nonatomic,strong)  OSSClient*  ossClient;

@end


@implementation SCAliyunUploadMananger

static SCAliyunUploadMananger *instance = nil;
+ (SCAliyunUploadMananger *)shareInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[SCAliyunUploadMananger alloc] init];
        }
    }
    return instance;
}

- (void)uploadImageArray:(NSArray *)imageArray {
    int count = imageArray.count;
    if (count) {
        NSMutableArray *array = [NSMutableArray array];
        __block int succeed = 0;
        for (int i = 0; i < count; i += 1) {
            UIImage *image = imageArray[i];
            [array addObject:@""];
            [self uploadImageActionRequest:image withRetry:3 withCallBack:^(NSString *url) {
                [array replaceObjectAtIndex:i withObject:url];
                succeed += 1;
                if (succeed == count) {
                    if ([self.delegate respondsToSelector:@selector(aliyunUploadManagerFinishdWithImageURLArray:)]) {
                        [self.delegate aliyunUploadManagerFinishdWithImageURLArray:array];
                    }
                }
            } withErrorCallBack:^(NSError *error) {
                if ([self.delegate respondsToSelector:@selector(aliyunUploadManagerError:)]) {
                    [self.delegate aliyunUploadManagerError:error];
                }
            }];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(aliyunUploadManagerFinishdWithImageURLArray:)]) {
            [self.delegate aliyunUploadManagerFinishdWithImageURLArray:@[]];
        }
    }
}

- (void)uploadImageActionRequest:(UIImage *)image withRetry:(int)retryCount withCallBack:(void(^)(NSString *))cb withErrorCallBack:(void(^)(NSError *))ecb {
    WS(WeakSelf);
    [SCAliyunUploadMananger uploadImage:image withCompressionQuality:0.5 withCallBack:^(NSString *url) {
        cb(url);
    } withErrorCallBack:^(NSError *error) {
        if (retryCount) {
            int r = retryCount - 1;
            [WeakSelf uploadImageActionRequest:image withRetry:r withCallBack:cb withErrorCallBack:ecb];
        } else {
            ecb(error);
        }
    }];
}

+ (void)uploadImage:(UIImage *)image withCompressionQuality:(CGFloat)cq withCallBack:(void(^)(NSString *url))cb withErrorCallBack:(void(^)(NSError *error))ecb {
    NSData *imageData = UIImageJPEGRepresentation(image, cq);
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@(1) forKey:@"num"];
    //   [params setObject:@"hello" forKey:@"token"];
    [[SCNetwork shareInstance]postWithUrl:STORYUPLOADAPP parameters:params success:^(id responseObject) {
        NSDictionary *aliyunParams = responseObject[@"data"];
        NSString *url = [NSString stringWithFormat:@"%@/%@.jpg", aliyunParams[@"host"], aliyunParams[@"uuidList"][0]];
        NSArray *uuidList = aliyunParams[@"uuidList"];
        
        if (uuidList.count) {
            [self uploadData:imageData withUrl:url withParams:aliyunParams withCallBack:cb];
        } else {
            ecb([SCNetworkError errorWithCode:responseObject[@"code"] msg:@"params uuid array empty"]);
        }
    } failure:^(NSError *error) {
        SCLog(@"aliyun params request error: %@",error);
        ecb(error);
    }];
}

//上传阿里云 拿到地址
+ (void)uploadData:(NSData *)data withUrl:(NSString *)url withParams:(NSDictionary *)params withCallBack:(void(^)(NSString *url))cb {
    NSString *kAliFileAccessKeyId = params[@"accessKeyId"];
    NSString *kAliFileAccessKeySecret = params[@"accessKeySecret"];
    NSString *kAliFileSecurityToken = params[@"securityToken"];
    NSString *endpoint = params[@"endPoint"];
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:kAliFileAccessKeyId secretKeyId:kAliFileAccessKeySecret securityToken:kAliFileSecurityToken];
    [SCAliyunUploadMananger shareInstance].ossClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    //
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    put.bucketName = params[@"bucket"];
    put.objectKey = [NSString stringWithFormat:@"%@.jpg", params[@"uuidList"][0]];
    put.uploadingData = data;
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 异步
         NSLog(@"bytesSent ==%lld,totalByteSent== %lld, totalBytesExpectedToSend ==%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask *putTask = [[SCAliyunUploadMananger shareInstance].ossClient putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!task.error) {
                SCLog(@"阿里云!");
                cb(url);
            } else {
                SCLog(@"阿里云!%@", task.error.description);
                cb(nil);
            }
        });
        return nil;
    }];
}

@end
