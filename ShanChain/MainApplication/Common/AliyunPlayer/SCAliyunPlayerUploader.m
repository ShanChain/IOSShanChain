//
//  SCAliyunPlayerUploader.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/19.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCAliyunPlayerUploader.h"

@interface SCAliyunPlayerUploader()<VODUploadSVideoClientDelegate>

@property (strong, nonatomic) VODUploadSVideoClient *client;

@property (copy, nonatomic) NSString *videoPath;

@property (copy, nonatomic) NSString *imagePath;

@property (nonatomic,strong)  VodSVideoInfo    *videoInfo;

@end

@implementation SCAliyunPlayerUploader

static SCAliyunPlayerUploader *instance = nil;

+ (SCAliyunPlayerUploader *)sharedInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[SCAliyunPlayerUploader alloc] init];
        }
    }
    
    return instance;
}

- (void)uploadWithVideoPath:(NSString *)videoPath withImagePath:(NSString *)imagePath title:(NSString*)title desc:(NSString*)desc{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // type 的值有normal和dynamic
    [params setObject:@"dynamic" forKey:@"type"];
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate = self;
    _client.maxRetryCount = 5;
    _client.timeoutIntervalForRequest = 15;
    _client.transcode = YES;
    self.videoPath = videoPath;
    self.imagePath = imagePath;
    WS(WeakSelf);
    [SCNetwork.shareInstance postWithUrl:ALIYUNPLAYERUPLOADER parameters:params success:^(id responseObject) {
        [SYProgressHUD hideHUD];
        NSDictionary *contentDict = responseObject[@"data"];
        if (contentDict != [NSNull null]) {
            NSString *accesseKeyId = contentDict[@"accessKeyId"];
            NSString *accessKeySecret = contentDict[@"accessKeySecret"];
            NSString *securityToken = contentDict[@"securityToken"];
            
            VodSVideoInfo *info = [VodSVideoInfo new];
            info.title = title;
            info.cateId = contentDict[@"cateId"];
            info.desc = desc;
            WeakSelf.videoInfo = info;
            [WeakSelf.client uploadWithVideoPath:videoPath imagePath:imagePath svideoInfo:info accessKeyId:accesseKeyId accessKeySecret:accessKeySecret accessToken:securityToken];
        }
    } failure:^(NSError *error) {
        [SYProgressHUD hideHUD];
    }];
}

- (void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl {
    
    NSString   *json = @{@"title":self.videoInfo.title,@"background":imageUrl,@"intro":self.videoInfo.desc,@"vidId":vid}.mj_JSONString;
    NSDictionary  *dic = @{@"userId":[SCCacheTool shareInstance].getCurrentUser,@"spaceId":[SCCacheTool shareInstance].getCurrentSpaceId,@"characterId":[SCCacheTool shareInstance].getCurrentCharacterId,@"dataString":json};
    
    weakify(self);
    [[SCNetwork shareInstance]postWithUrl:PLAY_ADD_URL parameters:dic success:^(id responseObject) {
        [SYProgressHUD showSuccess:@"发布成功"];
        [[SCAppManager shareInstance] popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SYProgressHUD showSuccess:@"发布失败"];
    }];

    if (self.videoPath && self.delegate && [self.delegate respondsToSelector:@selector(fileTransforSuccessWithIdentity:)]) {
        [self.delegate fileTransforSuccessWithIdentity:self.videoPath];
    }
    
}

- (void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    if (self.videoPath && self.delegate && [self.delegate respondsToSelector:@selector(fileTransforFailedWithIdentity:withError:)]) {
        [self.delegate fileTransforFailedWithIdentity:self.videoPath withError:[SCNetworkError errorWithCode:code msg:message]];
    }
}

- (void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    if (self.videoPath && self.delegate && [self.delegate respondsToSelector:@selector(fileTransforProgressWithIdentity:withProgress:)]) {
        [self.delegate fileTransforProgressWithIdentity:self.videoPath withProgress:(CGFloat)uploadedSize/totalSize];
    }
}
/**
 token过期
 */
- (void)uploadTokenExpired{
    
}

/**
 开始重试
 */
- (void)uploadRetry {
//    if (self.videoPath && self.delegate && [self.delegate respondsToSelector:@selector(fileTransforFailedWithIdentity:withError:)]) {
//        [self.delegate fileTransforFailedWithIdentity:self.videoPath withError:[SCNetworkError errorWithCode:@"99999" msg:@"上传失败"]];
//    }
}

/**
 重试完成，继续上传
 */
- (void)uploadRetryResume{
    
}


@end
