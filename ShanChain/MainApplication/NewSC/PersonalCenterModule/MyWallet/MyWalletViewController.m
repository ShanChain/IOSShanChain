//
//  MyWalletViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/16.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "MyWalletViewController.h"
#import "XMWebView.h"
#import "ShanChain-Swift.h"
#import <Foundation/Foundation.h>

#if PN_ENVIRONMENT == 3  //生产环境

#define WalletURL @"http://h5.qianqianshijie.com/wallet"

#else

#define WalletURL @"http://m.qianqianshijie.com/wallet"

#endif


@interface MyWalletViewController ()<XMWebViewDelegate,DUX_UploadUserIconDelegate>

@property (nonatomic, strong) XMWebView *webView;
@property (nonatomic, strong) NSData *imageData;
@end

@implementation MyWalletViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_webView ocAndJSInteractionWithRegisterHandlerName:@"testa" finishBlock:^(id data) {
        
//        SCLog(@"%@",dataDic);
        NSDictionary *dic = (NSDictionary *)data;
        UploadPhotePasswordView  *uploadView = [[UploadPhotePasswordView alloc]initWithFrame:self.view.frame];
        uploadView.imageViewTag = 214;
        uploadView.vc = self;
        uploadView.transferDic = dic;
        
//        weakify(uploadView);

        
        uploadView.closure = ^(BOOL  success, NSString * _Nonnull authCode) {
            
            [_webView JSAndOCSInteractionWithRegisterHandlerName:@"JSEcho" data:authCode];
//            [weak_uploadView removeFromSuperview];
        };
        [self.view addSubview:uploadView];

    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[XMWebView alloc] initWithFrame:self.view.frame viewType:WebViewTypeWkWebView];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //此处链接要写全
    if (NULLString(self.urlStr)) {
        self.urlStr = WalletURL;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}


-(void)viewWillAppear:(BOOL)animated{
   
    self.navigationController.navigationBarHidden = !self.isShowNav;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)_deallocCache{
    // 清除Cookie 和缓存
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)dealloc{
    [self _deallocCache];
}

-(NSDictionary *)setPar:(NSDictionary *)dic {
    
    /**
     let operationType = transferDic?["operationType"] as! String
     if operationType == "PostSale"{
     // 发布 出售
     tmp = String(format: "&%@&%@", transferDic?["imgHashValue"]as! String,transferDic?["orderDesc"]as! String)
     url = String(format: "/wallet/api/exchange/sell/pendingOrder/create?token=%@%@", SCCacheTool.shareInstance().getUserToken(),tmp)
     }else if operationType == "DigitalAssets" {
     // 发起委托交易
     
     }else if operationType == "LiftBond" {
     // 提券
     
     }else if operationType == "SellComfirmedList" {
     // 确认出售
     
     }else if operationType == "Transfer" {
     // 转账
     tmp = transferDic?["data"] as! String
     
     url = String(format: "/wallet/api/wallet/2.0/creatTransaction?token=%@%@", SCCacheTool.shareInstance().getUserToken(),tmp)
     }
     */
    
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:dic];
    [tmp removeObjectForKey:@"operationType"];
    if ([dic[@"operationType"] isEqualToString:@"PostSale"]) {
        
    }
    else if ([dic[@"operationType"] isEqualToString:@"DigitalAssets"]) {
        
    }
    else if ([dic[@"operationType"] isEqualToString:@"LiftBond"]) {
        
    }
    else if ([dic[@"operationType"] isEqualToString:@"SellComfirmedList"]) {
        
    }
    else if ([dic[@"operationType"] isEqualToString:@"Transfer"]) {

    }
    
    return dic;
}

#pragma maek - 子类重写
- (void)webViewDidStartLoad:(XMWebView *)webview {
    
}
- (void)webView:(XMWebView *)webview shouldStartLoadWithURL:(NSURL *)URL {
    NSString *requestString = [URL absoluteString];
    requestString= [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(!requestString){
        requestString = [URL absoluteString];
        [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    if ([requestString isEqualToString:WalletURL]) {
        NSMutableString  *urlString = [NSMutableString string];
        [urlString appendString:requestString];
        [urlString appendString:@"?"];
        [urlString appendString:[NSString stringWithFormat:@"characterId=%@",[SCCacheTool shareInstance].getCurrentCharacterId]];
        [urlString appendString:@"&"];
        [urlString appendString:[NSString stringWithFormat:@"token=%@",[SCCacheTool shareInstance].getUserToken]];
        [urlString appendString:@"&"];
        [urlString appendString:[NSString stringWithFormat:@"userId=%@",[SCCacheTool shareInstance].getCurrentUser]];
        [urlString appendString:@"&"];
        [urlString appendString:[NSString stringWithFormat:@"channel=%@",SC_APP_CHANNEL]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
     
    }

    NSDictionary  *  urlParameter = [URL.absoluteString getURLParameters].copy;
    [urlParameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"toLogin"] && [obj isEqualToString:@"true"]) {
             [[SCAppManager shareInstance] logout];
        }
        
        if ([key isEqualToString:@"toPwd"] && [obj isEqualToString:@"true"]) {
            MyWalletPasswordViewController *wallPassword = [[MyWalletPasswordViewController alloc]init];
            [self.navigationController pushViewController:wallPassword animated:YES];
        }
        
        if ([key isEqualToString:@"toPrev"] && [obj isEqualToString:@"true"]) {
//            if (self.navigationController.navigationBarHidden) {
//                self.navigationController.navigationBarHidden = NO;
//            }
           // [self dismissViewControllerAnimated:YES completion:NULL];
            [self backViewController];
        }
        
        if ([key isEqualToString:@"comfirm"] && [obj isEqualToString:@"true"]) {
            NSMutableString  *urlString = [NSMutableString string];
            [urlString appendString:WalletURL];
            [urlString appendString:@"?"];
            [urlString appendString:[NSString stringWithFormat:@"characterId=%@",[SCCacheTool shareInstance].getCurrentCharacterId]];
            [urlString appendString:@"&"];
            [urlString appendString:[NSString stringWithFormat:@"token=%@",[SCCacheTool shareInstance].getUserToken]];
            [urlString appendString:@"&"];
            [urlString appendString:[NSString stringWithFormat:@"userId=%@",[SCCacheTool shareInstance].getCurrentUser]];
            [urlString appendString:@"&"];
            [urlString appendString:[NSString stringWithFormat:@"channel=%@",SC_APP_CHANNEL]];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }
        
//        if ([key isEqualToString:@"toUpload"] && [obj isEqualToString:@"true"]) {
//            SCLog(@"我是大连人");
//        }
        
    }];
    
}
- (void)webView:(XMWebView *)webview didFinishLoadingURL:(NSURL *)URL {
    
}
- (void)webView:(XMWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error {
    NSLog(@"error=%@",error);
}


#pragma mark  -DUX_UploadUserIconDelegate
-(void)uploadImageToServerWithImage:(UIImage *)image Tag:(NSInteger)tag {
    
    
    
    self.imageData = UIImagePNGRepresentation(image);
    
//    NSString *autoCode = [[SCCacheTool shareInstance] getAuthCode];
//    [_webView JSAndOCSInteractionWithRegisterHandlerName:@"JSEcho" data:autoCode];
//    SCLog(@"%@--%ld--%@",image,tag,self.imageData);
//    NSString *tmp = [[NSString alloc] initWithData:self.imageData
//                                         encoding:NSUTF8StringEncoding];
//    if (!tmp) { // 解决NSData转化为NSString时，可能返回nil的情况
//        NSData *data = ALUTF8NSData(self.imageData);
//        tmp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    NSDictionary *tmp = @{@"imageData":self.imageData};
//    
//    [_webView JSAndOCSInteractionWithRegisterHandlerName:@"JSEcho" data:info];
}



@end
