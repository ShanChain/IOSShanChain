//
//  SCNetwork.m
//  ShanChain
//
//  Created by flyye on 2017/10/23.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "SCNetwork.h"
#import "SCNetworkError.h"
#import "UrlConstants.h"
#import "SCCacheTool.h"



#define ACCEPT_TYPE_NORMAL @[@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"application/x-www-form-urlencodem"]
#define ACCEPT_TYPE_IMAGE @[@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json"]

static const BOOL IS_USE_HTTPS = YES;
static double  const  TIME_OUT_INTERVAL = 25.0;

typedef void (^NetworkStatusBlock)(AFNetworkReachabilityStatus status);

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
        [_afManager.requestSerializer setTimeoutInterval:60];
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
    
    NSString *userId = [[SCCacheTool shareInstance] getCurrentUser];
    NSString *token = @"";
    if(userId && ![userId isEqualToString:@""]){
         token = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:@"token"];
    }
    
    NSMutableDictionary *params = [parameters mutableCopy];
    if ([token isNotBlank]) {
        [params setValue:token forKey:@"token"];
    }
    if ([[JPUSHService registrationID]_notEmpty]) {
        [params setValue:[JPUSHService registrationID] forKey:@"deviceToken"];
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

    id kparameters;
    if ([url containsString:CHANGE_USER_CHARACTER]) {
        NSMutableDictionary  *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [mDic setObject:[SCCacheTool shareInstance].characterModel.characterInfo.characterId forKey:@"characterId"];
        [mDic  setObject:token forKey:@"token"];
        [mDic  setObject:userId forKey:@"userId"];
        [mDic  setObject:params.mj_JSONString forKey:@"dataString"];
        kparameters = mDic.copy;
    }else{
        kparameters = params;
    }
    [_afManager POST:url parameters:kparameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString  *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:SC_COMMON_SUC_CODE] || [code isEqualToString:SC_PHONENUMBER_NOBIND]) {
            success(responseObject);
        } else {
            NSString *msg;
            if (!NULLString(responseObject[@"message"])) {
                msg = responseObject[@"message"];
            }
            
            if (!NULLString(responseObject[@"msg"])) {
                msg = responseObject[@"msg"];
            }
            
            if (!msg) {
                msg = @"操作失败";
            }
//            SCLog(@"Request error%@", responseObject);
            if([code isEqualToString:SC_REQUEST_TOKEN_EXPIRE]){
                [[SCAppManager shareInstance] logout];
            } else if ([code isEqualToString:SC_REALNAME_AUTHENTICATE]){
                [[SCAppManager shareInstance] realNameAuthenticate];
            } else if ([code isEqualToString:SC_SHARE_NOOPEN]){
                [SYProgressHUD showError:msg];
            }else if ([code isEqualToString:SC_ERROR_WalletAccountNotexist] || [code isEqualToString:SC_ERROR_WalletPasswordNotexist]) {
                [[SCAppManager shareInstance]configWalletInfoWithType:code];
            } else if( [code isEqualToString:SC_ERROR_WalletPasswordInvalid]){
                [[SCAppManager shareInstance]againUploadPasswordWithUrl:url parameters:((NSDictionary*)kparameters).mutableCopy Callback:^(NSString *authCode, NSString *_url, NSDictionary *_parameters) {
                    NSMutableDictionary  *mDic = [NSMutableDictionary dictionaryWithDictionary:_parameters];
                    [mDic setObject:authCode forKey:@"authCode"];
                    [[SCNetwork shareInstance]postWithUrl:_url parameters:mDic.copy success:success failure:failure];
                }];
       
            }else {
                [YYHud showError:msg];
                if (failure) {
                    failure([SCNetworkError errorWithCode:(NSInteger)responseObject[@"code"] msg:msg]);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SCLog(@"Error%@",error);
        [YYHud showError:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        if (failure) {
            failure(error);
        }
    }];
}



- (NSData*)getHttpBody:(NSDictionary*)params{
    // 过滤空字符串
    NSMutableDictionary  *mdic = [NSMutableDictionary dictionaryWithCapacity:0];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ((!([obj isKindOfClass:[NSString class]] && NULLString(obj))) && obj) {
            [mdic setObject:obj forKey:key];
        }
    }];
    // 过滤json里面的转义字符
    NSData* json = [NSJSONSerialization dataWithJSONObject:mdic.copy options:NSJSONWritingPrettyPrinted error:nil];
    NSString  *str = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"\r\n"withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t"withString:@""];
   // str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (void)HH_postWithUrl:(NSString *)url params:(NSDictionary *)parameters showLoading:(BOOL)show callBlock:(void(^)(HHBaseModel *baseModel,NSError *error))callBlock{
    
    NSMutableString  *mutabUrl = [[NSMutableString alloc]initWithString:url];
    if (getRequstToken()._notEmpty && ![mutabUrl containsString:@"token="]) {
        [mutabUrl appendFormat:@"?token=%@",getRequstToken()];
    }
    url = mutabUrl.copy;
    
    
#if TARGET_OS_IPHONE
    [SCNetwork netWorkStatus:^(AFNetworkReachabilityStatus status) {
        if (status < 1) {
            [HHTool showError:NSLocalizedString(@"sc_Please_check_the_networksettings", nil)];
            return ;
            
        }
    }];
#endif
    if (show) {
        [HHTool showChrysanthemum];
    }
    
    if (IS_USE_HTTPS) {
        [_afManager setSecurityPolicy:[self customSecurityPolicy]];
    }
    NSString *token = getRequstToken();
    NSMutableDictionary *params = [parameters mutableCopy];
    if ([token isNotBlank]) {
        [params setValue:token forKey:@"token"];
    }else{
        [params setValue:@"3_69eb6205f2714244b306b07c6d1d7d1a1541750543777" forKey:@"token"];
        [params setObject:@"95" forKey:@"characterId"];
    }
    if ([[JPUSHService registrationID]_notEmpty]) {
        [params setValue:[JPUSHService registrationID] forKey:@"deviceToken"];
    }
    if (![url containsString:SC_BASE_URL]) {
        url = [SC_BASE_URL stringByAppendingString:url];
    }
    [self apendTOBaseParams:params];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    request.timeoutInterval= TIME_OUT_INTERVAL;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:[self getHttpBody:params]];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_NORMAL];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (show) {
            [HHTool immediatelyDismiss];
        }
        if (error) {
            callBlock(nil,error);
            
            NSString  *msg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (error.code == SC_NOTENOUGH.integerValue) {
                msg = @"您的余额不足";
            }
            [YYHud showError:msg];
            return ;
        }
        
        HHBaseModel  *baseModel;
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            baseModel = [HHBaseModel yy_modelWithDictionary:dictionary];
        }else{
            baseModel = [HHBaseModel yy_modelWithDictionary:responseObject];
        }
        
        if ([baseModel.code isEqualToString:SC_COMMON_SUC_CODE] || [baseModel.code isEqualToString:SC_WALLET_COMMON_SUC_CODE]) {
            callBlock(baseModel,nil);
        }else{
            if ([baseModel.code isEqualToString:SC_ERROR_WalletAccountNotexist] || [baseModel.code isEqualToString:SC_ERROR_WalletPasswordNotexist]) {
                [[SCAppManager shareInstance]configWalletInfoWithType:baseModel.code];
            }
            
             if([baseModel.code isEqualToString:SC_ERROR_WalletPasswordInvalid]){
                 
                 [[SCAppManager shareInstance]againUploadPasswordWithUrl:url parameters:params.mutableCopy Callback:^(NSString *authCode, NSString *_url, NSDictionary *_parameters) {
                     NSMutableDictionary  *mDic = [NSMutableDictionary dictionaryWithDictionary:_parameters];
                      [mDic setObject:authCode forKey:@"authCode"];
                      [[SCNetwork shareInstance]HH_postWithUrl:_url params:mDic.copy showLoading:show callBlock:callBlock];
                 }];
                 
            }
            
            if([baseModel.code isEqualToString:SC_REQUEST_TOKEN_EXPIRE]){
                [[SCAppManager shareInstance] logout];
            }
            
            if (!NULLString(baseModel.message)) {
                if (baseModel.code.integerValue == SC_NOTENOUGH.integerValue) {
                    baseModel.message = @"您的余额不足";
                }
                [HHTool showError:baseModel.message];
            }
        }
        
    }] resume];
}


-(void)v1_postWithUrl:(NSString *)url params:(id)parameters showLoading:(BOOL)show callBlock:(void (^)(HHBaseModel *baseModel, NSError *error))callBlock{
    
    // 因业务需求需要
    if ([url hasPrefix:@"/wallet"]) {
        [self HH_postWithUrl:url params:parameters showLoading:show callBlock:callBlock];
        return;
    }
    
    
#if TARGET_OS_IPHONE
    [SCNetwork netWorkStatus:^(AFNetworkReachabilityStatus status) {
        if (status < 1) {
            [HHTool showError:NSLocalizedString(@"sc_Please_check_the_networksettings", nil)];
            callBlock(nil,[NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:nil]);
            return ;
            
        }
    }];
#endif
    if (show) {
        [HHTool showChrysanthemum];
       
    }
    
    [self postWithUrl:url parameters:parameters success:^(id responseObject) {
        if (show) {
            [HHTool immediatelyDismiss];
        }
        HHBaseModel  *baseModel = [HHBaseModel yy_modelWithDictionary:responseObject];
        callBlock(baseModel,nil);
        
    } failure:^(NSError *error) {
        if (show) {
            [HHTool immediatelyDismiss];
        }
        callBlock(nil,error);
        [YYHud showError:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
}


- (void)HH_GetWithUrl:(NSString *)url parameters:(id)parameters showLoading:(BOOL)show callBlock:(void (^)(HHBaseModel *baseModel, NSError *error))callBlock{
    
    
    
#if TARGET_OS_IPHONE
    [SCNetwork netWorkStatus:^(AFNetworkReachabilityStatus status) {
        if (status < 1) {
            [HHTool showError:NSLocalizedString(@"sc_Please_check_the_networksettings", nil)];
            callBlock(nil,[NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:nil]);
            return ;
        }
    }];
#endif
    if (show) {
//        [HHTool showChrysanthemum];
    }
    
    [self getWithUrl:url parameters:parameters success:^(id responseObject) {
        if (show) {
            [HHTool immediatelyDismiss];
        }
        HHBaseModel  *baseModel = [HHBaseModel yy_modelWithDictionary:responseObject];
        callBlock(baseModel,nil);
        
    } failure:^(NSError *error) {
        if (show) {
            [HHTool immediatelyDismiss];
        }
        callBlock(nil,error);
        if (error.code != SC_Token_Already_Exist.integerValue) {
            [YYHud showError:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }
        
    }];
    
}


static NSString* getRequstToken(){
    NSString *userId = @"";
    userId = [[SCCacheTool shareInstance] getCurrentUser];
    NSString *token = @"";
    if(userId && ![userId isEqualToString:@""] ){
        token = [[SCCacheTool shareInstance] getCacheValueInfoWithUserID:userId andKey:@"token"];
    }
    return token;
}

- (void)getWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
//    NSMutableString  *mutabUrl = [[NSMutableString alloc]initWithString:url];
//    if (getRequstToken()._notEmpty) {
//        [mutabUrl appendFormat:@"?token=%@",getRequstToken()];
//    }
//    url = mutabUrl.copy;
    
    if (IS_USE_HTTPS) {
        [_afManager setSecurityPolicy:[self customSecurityPolicy]];
    }
    _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_NORMAL];
    _afManager.requestSerializer.timeoutInterval = TIME_OUT_INTERVAL;
    
    NSMutableDictionary *params = [parameters mutableCopy];
    if([parameters objectForKey:@"token"] == nil || [[parameters objectForKey:@"token"]  isEqual: @""]){
        [params setValue:getRequstToken() forKey:@"token"];
    }
    if ([[JPUSHService registrationID]_notEmpty]) {
        [params setValue:[JPUSHService registrationID] forKey:@"deviceToken"];
    }
    if([url hasPrefix:@"/"] && ![url containsString:SC_BASE_URL]) {
        url = [SC_BASE_URL stringByAppendingString:url];
    }
    
    
    [self apendTOBaseParams:params];
    [_afManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString  *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:SC_COMMON_SUC_CODE] || [code isEqualToString:SC_WALLET_COMMON_SUC_CODE] || [code isEqualToString:SC_REALNAME_NOMATCH]) {
            SCLog(@"success");
            success(responseObject);
        }else if ([code isEqualToString:SC_REALNAME_AUTHENTICATE]){
            [[SCAppManager shareInstance] realNameAuthenticate];
        } else if([code isEqualToString:SC_REQUEST_TOKEN_EXPIRE]){
            [[SCAppManager shareInstance] logout];
        }else  if ([code isEqualToString:SC_NOTENOUGH] ) {
            [HHTool showError:@"您的余额不足"];
        }else if ([code isEqualToString:SC_ERROR_WalletAccountNotexist] || [code isEqualToString:SC_ERROR_WalletPasswordNotexist]) {
            [[SCAppManager shareInstance]configWalletInfoWithType:code];
        } else if( [code isEqualToString:SC_ERROR_WalletPasswordInvalid]){
            [[SCAppManager shareInstance]againUploadPasswordWithUrl:url parameters:params.mutableCopy Callback:^(NSString *authCode, NSString *_url, NSDictionary *_parameters) {
                NSMutableDictionary  *mDic = [NSMutableDictionary dictionaryWithDictionary:_parameters];
                [mDic setObject:authCode forKey:@"authCode"];
                [[SCNetwork shareInstance]getWithUrl:_url parameters:mDic.copy success:success failure:failure];
            }];
            
        }else if ([code isEqualToString:SC_ERROR_WalletSavePasswordFail]) {
            // 保存密码失败
            [HHTool showError:responseObject[@"msg"]];
        }else{
            SCLog(@"Request error%@", responseObject);
            
            NSString *msg = @"Request data error";
            if (!NULLString(responseObject[@"message"])) {
                msg = responseObject[@"message"];
            }
            
            if (!NULLString(responseObject[@"msg"])) {
                msg = responseObject[@"msg"];
            }
            
            failure([SCNetworkError errorWithCode:code.integerValue msg:msg]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 *  图片上传
 *
 *  @param imgArr 图片数组
 *  @param callBlock  返回图片地址数组
 */


- (void)HH_uploadFileWithArr:(NSArray*)imgArr url:(NSString *)url parameters:(id)parameters showLoading:(BOOL)show callBlock:(void(^)(HHBaseModel *baseModel,NSError *error))callBlock{
#if TARGET_OS_IPHONE
    [SCNetwork netWorkStatus:^(AFNetworkReachabilityStatus status) {
        if (status < 1) {
            [HHTool showError:NSLocalizedString(@"sc_Please_check_the_networksettings", nil)];
            callBlock(nil,[NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:nil]);
            return ;
        }
    }];
#endif
    if (show) {
        [HHTool showChrysanthemum];
    }
    [self uploadImagesWihtImgArr:imgArr url:url parameters:parameters block:^(id objc, BOOL success) {
        
        if (show) {
            [HHTool immediatelyDismiss];
        }
        if (success) {
            HHBaseModel  *baseModel = [HHBaseModel yy_modelWithDictionary:objc];
            callBlock(baseModel,nil);
        }else{
            callBlock(nil,objc);
        }
    }];
    
}

- (void)uploadImagesWihtImgArr:(NSArray *)imgArr
                           url:(NSString *)url
                    parameters:(id)parameters
                         block:(void (^)(id objc,BOOL success))block{
    if([url hasPrefix:@"/"] && ![url containsString:SC_BASE_URL]){
        url = [SC_BASE_URL stringByAppendingString:url];
    }

    // 基于AFN3.0+ 封装的HTPPSession句柄
    _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_IMAGE];
//    if ([url containsString:@"/wallet/api/wallet/2.0/hideInfo"]) {
//        _afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    }
    
    // 在parameters里存放照片以外的对象
    NSMutableDictionary *params = [parameters mutableCopy];
//    if([parameters objectForKey:@"token"] == nil || [[parameters objectForKey:@"token"]  isEqual: @""]){
//        [params setValue:getRequstToken() forKey:@"token"];
//    }
    
    
    BOOL  isURL = NO;
    if ([imgArr.lastObject isKindOfClass:[NSString class]]) {
        isURL = YES;
    }
    
    NSMutableString  *mutabUrl = [[NSMutableString alloc]initWithString:url];
    [mutabUrl appendFormat:@"?token=%@",getRequstToken()];
    [_afManager POST:mutabUrl.copy parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imgArr.count; i++) {
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
            SCLog(@"%@",imgArr[i]);
            if (isURL) {
                NSError  *error = nil;
                [formData appendPartWithFileURL:[NSURL URLWithString:imgArr[i]] name:@"file" fileName:fileName mimeType:@"image/jpeg" error:&error];
            }else{
                [formData appendPartWithFileData:imgArr[i] name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }
            
            
//            [formData appendPartWithInputStream:[[NSInputStream alloc]initWithData:imgArr[i]] name:@"file" fileName:fileName length:((NSData*)imgArr[i]).length mimeType:@"image/jpeg"];
        
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        SCLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if ([url containsString:@"/wallet/api/wallet/2.0/hideInfo"]) {
//            SCLog(@"%@",responseObject);
//            
//            return;
//        }
        NSString  *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:SC_COMMON_SUC_CODE] || [code isEqualToString:SC_WALLET_COMMON_SUC_CODE] || [code isEqualToString:SC_REALNAME_NOMATCH]) {
            SCLog(@"success");
            block(responseObject,YES);
        }else if ([code isEqualToString:SC_REALNAME_AUTHENTICATE]){
            [[SCAppManager shareInstance] realNameAuthenticate];
        } else if([code isEqualToString:SC_REQUEST_TOKEN_EXPIRE]){
            [[SCAppManager shareInstance] logout];
        }else  if ([code isEqualToString:SC_NOTENOUGH] ) {
            [HHTool showError:@"您的余额不足"];
        }else  if ([code isEqualToString:SC_ERROR_WalletPasswordInvalid] ) {
            [HHTool showError:@"验证失败，请上传正确的二维码图片"];
        }else{
            SCLog(@"Request error%@", responseObject);
            
            NSString *msg = @"Request data error";
            if (!NULLString(responseObject[@"message"])) {
                msg = responseObject[@"message"];
            }
            
            if (!NULLString(responseObject[@"msg"])) {
                msg = responseObject[@"msg"];
            }
            block([SCNetworkError errorWithCode:code.integerValue msg:msg],NO);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SCLog(@"failure error%@", error.userInfo[@"NSUnderlyingError"]);
        NSError *tmp = error.userInfo[@"NSUnderlyingError"];
        NSHTTPURLResponse *response = tmp.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = response.statusCode;
        if (statusCode == 413) {
            // 413 上传图片过大
            [HHTool showError:@"上传图片有误！"];
        }
        NSString  *mimeType = task.response.MIMEType;
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            block(@{@"data":errorData,@"code":@"000000",@"message":@""},YES);
        }else{
            block(error,NO);
        }
        
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


- (void)cancelTask{
    [_afManager.operationQueue cancelAllOperations];
}

- (void)apendTOBaseParams:(NSDictionary*)params{
    [params setValue:@"ios" forKey:@"os"];
 
    
    return;
}


+ (void)netWorkStatus:(NetworkStatusBlock)block {
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BLOCK_EXEC(block,status);
    }];
}

/// 转账 -R
- (void)transferWithUrl:(NSString *)url data:(NSDictionary *)dic block:(void (^)(id objc,BOOL success))block {
    
    if([url hasPrefix:@"/"] && ![url containsString:SC_BASE_URL]){
        url = [SC_BASE_URL stringByAppendingString:url];
    }
    

    NSString *imgUrl = dic[@"file"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
    
    _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPT_TYPE_IMAGE];
    
        
    [_afManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSNumber class]]) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *string = [formatter stringFromNumber:obj];
                [formData appendPartWithFormData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                            name:key];
            }else {
                NSString *str = (NSString *)obj;
                [formData appendPartWithFormData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                            name:key];
            }
            
            
        }];

        NSError  *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:imgUrl] name:@"file" fileName:fileName mimeType:@"image/jpeg" error:&error];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SCLog(@"%@",responseObject[@"msg"]);

        block(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SCLog(@"%@",error);
        block(error,NO);
    }];
}

@end


