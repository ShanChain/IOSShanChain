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

#if PN_ENVIRONMENT == 3  //生产环境

#define WalletURL @"http://h5.qianqianshijie.com/wallet"

#else

#define WalletURL @"http://m.qianqianshijie.com/wallet"

#endif


@interface MyWalletViewController ()<XMWebViewDelegate>

@property (nonatomic, strong) XMWebView *webView;


@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[XMWebView alloc] initWithFrame:self.view.frame viewType:WebViewTypeWkWebView];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
}


-(void)viewWillAppear:(BOOL)animated{
    if (!self.isShowNav) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    //此处链接要写全
    if (NULLString(self.urlStr)) {
        self.urlStr = WalletURL;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
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
            if (self.navigationController.navigationBarHidden) {
                self.navigationController.navigationBarHidden = NO;
            }
            [self.navigationController popViewControllerAnimated:YES];
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
        
    }];
    
}
- (void)webView:(XMWebView *)webview didFinishLoadingURL:(NSURL *)URL {
    
}
- (void)webView:(XMWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error {
    NSLog(@"error=%@",error);
}


@end
