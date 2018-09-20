//
//  SCNetwork.m
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <React/RCTConvert.h>
#import <React/RCTBridgeModule.h>

#import "SCNetwork.h"
#import "SCNetworkError.h"
#import "UrlConstants.h"
#import "SCCacheTool.h"


#define ACCEPT_TYPE_NORMAL @[@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencodem"]
#define ACCEPT_TYPE_IMAGE @[@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json"]

static const BOOL IS_USE_HTTPS = YES;



@interface SCNetwork ()

@property(nonatomic,strong)AFHTTPSessionManager *afManager;

@end
NSString *SCRequestErrDomain = @"SCRequestErrDomain";

@implementation SCNetwork


+(SCNetwork *)shareInstance{
    static dispatch_once_t onceToken;
    static SCNetwork *instance = nil;
    if (instance == nil) {
        dispatch_once(&onceToken, ^{
            instance = [[SCNetwork alloc]init];
        });
    }
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _afManager = [AFHTTPSessionManager manager];
        [_afManager.requestSerializer setTimeoutInterval:30];
        [_afManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
        _afManager.requestSerializer     = [AFHTTPRequestSerializer serializer];
        _afManager.responseSerializer    = [AFJSONResponseSerializer serializer];
        _afManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
     
    }
    return self;
}


//常用网络请求方法
- (void)postWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure {
//     SCLog(@"url:%@,parameters:%@",url,parameters);
    if (IS_USE_HTTPS) {
        [_afManager setSecurityPolicy:[self customSecurityPolicy]];
    }
    NSString *userId = @"";
    userId = [[SCCacheTool shareInstance] getCurrentUser];
    NSString *token = @"";
    NSString *userIdString = [userId stringByAppendingString:@"_"];
    if(userId && ![userId isEqualToString:@""] ){
         token = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:@"token"];
    }
    
   
    NSMutableDictionary *params = [parameters mutableCopy];
    if ([token isNotBlank]) {
        [params setValue:token forKey:@"token"];
    }
    
    if([url hasPrefix:@"/"]) {
        // 临时测试代码
        if ([url hasPrefix:@"/hx"]) {
            url = [SC_BASE_PORT_8082 stringByAppendingString:url];
        }else if([url isEqualToString:STORYUPLOADAPP] || [url isEqualToString:COMMONCHECKVERSION] || [url isEqualToString:ALIYUNPLAYERUPLOADER]){
            url = [SC_BASE_PORT_8083 stringByAppendingString:url];
        }else{
            url = [SC_BASE_URL stringByAppendingString:url];
        }
    }
    [self apendTOBaseParams:params];
    _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_NORMAL];
    [_afManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
            success(responseObject);
        } else {
//            SCLog(@"Request error%@", responseObject);
            if([responseObject[@"code"] isEqualToString:SC_REQUEST_TOKEN_EXPIRE]){
                [[SCAppManager shareInstance] logout];
            } else {
                NSString *msg = responseObject[@"message"];
                if (!msg) {
                    msg = @"操作失败";
                }
                if (failure) {
                    failure([SCNetworkError errorWithCode:(NSInteger)responseObject[@"code"] msg:msg]);
                } else {
                    [SYProgressHUD showError:msg];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SCLog(@"Error%@",error);
        if (failure) {
            failure(error);
        } else {
            [SYProgressHUD showError:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }
    }];
}

- (void)getWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    if (IS_USE_HTTPS) {
        [_afManager setSecurityPolicy:[self customSecurityPolicy]];
    }
    _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_NORMAL];
    NSString *userId = @"";
    userId = [[SCCacheTool shareInstance] getCurrentUser];
    NSString *token = @"";
    NSString *userIdString = [userId stringByAppendingString:@"_"];
    if(userId && ![userId isEqualToString:@""] ){
        token = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:@"token"];
    }
    
    NSMutableDictionary *params = [parameters mutableCopy];
    if([parameters objectForKey:@"token"] == nil || [parameters objectForKey:@"token"] == @""){
        [params setValue:token forKey:@"token"];
    }
    if([url hasPrefix:@"/"]) {
        url = [SC_BASE_URL stringByAppendingString:url];
    }
    [self apendTOBaseParams:params];
    [_afManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
            SCLog(@"success");
            success(responseObject);
        } else {
            SCLog(@"Request error%@", responseObject);
            failure([SCNetworkError errorWithCode:(NSInteger)responseObject[@"code"] msg:@"Request data error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 *  图片上传
 *
 *  @param imgArr 图片数组
 *  @param block  返回图片地址数组
 */
- (void)uploadImagesWihtImgArr:(NSArray *)imgArr
                           url:(NSString *)url
                    parameters:(id)parameters
                         block:(void (^)(id objc,BOOL success))block{
    if([url hasPrefix:@"/"]){
        url = [SC_BASE_URL stringByAppendingString:url];
    }
    // 基于AFN3.0+ 封装的HTPPSession句柄
    _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_IMAGE];
    // 在parameters里存放照片以外的对象
    [_afManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imgArr.count; i++) {
            UIImage *image = imgArr[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"multipartFile" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        SCLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,NO);
    }];
}

- (void)downFileWithUrl:(NSString *)urlString
                  block:(void (^)(id objc,BOOL success))block{
    if([urlString hasPrefix:@"/"]){
        urlString = [SC_BASE_URL stringByAppendingString:urlString];
    }
  
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_afManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        SCLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        SCLog(@"默认下载地址%@",targetPath);
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        SCLog(@"%@---%@", response, filePath);
        block(filePath,YES);
    }];
}

-(AFSecurityPolicy *)customSecurityPolicy{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"api.shanchain.com" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;//是否允许CA不信任的证书通过
    securityPolicy.validatesDomainName = NO;//是否验证主机名
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    return securityPolicy;
}

- (void)rnRequest:(NSDictionary *)options
      successCallback:(RCTResponseSenderBlock)successCallback
        errorCallBack:(RCTResponseErrorBlock)errorCallBack {
    if (options == nil) {
        NSError *err = [SCNetworkError errorWithCode:SC_REQUEST_NO_PARAMS msg:@"参数为空"];
        if (errorCallBack) {
            errorCallBack(err);
        }
        return;
    }
    
    NSString *path = [RCTConvert NSString:options[@"path"]];
    NSString *method = [RCTConvert NSString:options[@"method"]];
    NSDictionary *params = [RCTConvert NSDictionary:options[@"params"]];
    
    path = (path == nil) ? @"" : path;
    
    if ([method isEqualToString:@"post"]) {
        [self postWithUrl:path parameters:params success:^(id  _Nullable responseObject) {
            successCallback(@[responseObject]);
        } failure:^(NSError * _Nonnull error) {
            errorCallBack(error);
        }];
    }
    if ([method isEqualToString:@"get"]) {
        [self getWithUrl:path parameters:params success:^(id  _Nullable responseObject) {
            successCallback(@[responseObject]);
        } failure:^(NSError * _Nonnull error) {
            successCallback(error);
        }];
    }
}

- (void)cancelTask{
    [_afManager.operationQueue cancelAllOperations];
}

- (void)apendTOBaseParams:(NSDictionary*)params{
    [params setValue:@"ios" forKey:@"Os"];
    return;
}

@end


