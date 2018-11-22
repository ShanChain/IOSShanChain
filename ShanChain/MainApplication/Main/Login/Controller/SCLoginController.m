//
//  SCLoginController.m
//  ShanChain
//
//  Created by krew on 2017/5/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCLoginController.h"
#import "SCTabbarController.h"
#import "SCPhoneRegisterController.h"
#import "SCInitPasswordController.h"
#import <ShareSDK/ShareSDK.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "RNTabbarController.h"
#import "SCCacheTool.h"
#import "SYStoryMarkController.h"
#import "SCBaseNavigationController.h"
#import "ShanChain-Swift.h"
#import "BMKTestLocationViewController.h"
#import "SCCharacterModel.h"

#define K_USERNAME @"K_USERNAME"

@interface SCLoginController ()<UITextFieldDelegate>{
    BOOL _keyboardIsShown;
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UITextField   *nameField;
@property (nonatomic, strong) UITextField   *pwdField;
@property (nonatomic, strong) UIButton      *forgetPwdBtn;

@property (nonatomic, strong) UIButton      *loginBtn;
@property (nonatomic, strong) UIButton      *registerBtn;
@property (nonatomic, strong) UIButton      *rnDemoBtn;
@property (nonatomic, strong) UIButton      *socialBtn;

@property (nonatomic, strong) UIView        *socialView;
@property (nonatomic, assign) CGFloat       currOffsetY;
@property (nonatomic, strong) UIButton      *weiBtn;
@property (nonatomic, strong) UIButton      *qqBtn;
@property (nonatomic, strong) UIButton      *weibBtn;

@end

@implementation SCLoginController
#pragma mark -懒加载

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UITextField *)nameField{
    if (!_nameField) {
        _nameField = [SYUIFactory textFieldWithPlacehold:@"请输入账号" withFont:[UIFont systemFontOfSize:14] withColor:[UIColor blackColor]];
        [_nameField makeLayerWithRadius:8.0f withBorderColor:RGB(221, 221, 221) withBorderWidth:1.0f];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _nameField.leftView = leftView;
        _nameField.delegate = self;
        if (!NULLString([[NSUserDefaults standardUserDefaults]objectForKey:K_USERNAME])) {
            _nameField.text = [[NSUserDefaults standardUserDefaults]objectForKey:K_USERNAME];
        }
    }
    return _nameField;
}

-(UITextField *)pwdField{
    if (!_pwdField) {
        _pwdField = [SYUIFactory textFieldWithPlacehold:@"请输入密码" withFont:[UIFont systemFontOfSize:14] withColor:[UIColor blackColor]];
        [_pwdField makeLayerWithRadius:8.0f withBorderColor:RGB(221, 221, 221) withBorderWidth:1.0f];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _pwdField.leftView = leftView;
        _pwdField.secureTextEntry=YES;
        _pwdField.delegate = self;
    }
    return _pwdField;
}

-(UIButton *)forgetPwdBtn{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:RGB(221, 221, 221) forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"abs_login_btn_rectangle_default"] forState:UIControlStateNormal];
    }
    return _loginBtn;
}

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:RGB(59, 186, 200) forState:UIControlStateNormal];
        [_registerBtn makeLayerWithRadius:8.0f withBorderColor:RGB(59, 186, 200) withBorderWidth:1.0f];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

-(UIButton *)socialBtn{
    if (!_socialBtn) {
        _socialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_socialBtn setTitle:@"第三方登录" forState:UIControlStateNormal];
        [_socialBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _socialBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _socialBtn.userInteractionEnabled = NO;
    }
    return _socialBtn;
}

-(UIView *)socialView{
    if (!_socialView) {
        _socialView = [UIView new];
        self.socialView=_socialView;
    }
    return _socialView;
}

-(UIButton *)weiBtn{
    if (!_weiBtn) {
        _weiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_weiBtn setBackgroundImage:[UIImage imageNamed:@"abs_login_btn_wechat_default"] forState:UIControlStateNormal];
        [_weiBtn addTarget:self action:@selector(weiXinLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiBtn;
}

-(UIButton *)qqBtn{
    if (!_qqBtn) {
        _qqBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_qqBtn setBackgroundImage:[UIImage imageNamed:@"abs_login_btn_qq_default"] forState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(qqLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqBtn;
}

-(UIButton *)weibBtn{
    if (!_weibBtn) {
        _weibBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_weibBtn setBackgroundImage:[UIImage imageNamed:@"abs_login_btn_weibo_default"] forState:UIControlStateNormal];
        [_weibBtn addTarget:self action:@selector(weiBLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weibBtn;
}

#pragma mark -系统方法
//- (void)registerNotification {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:self.view.window];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(255, 255, 255);
    
    self.title=@"登录马甲";
    [self makeSubViews];
    [self setKeyBoardAutoHidden];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        // 登陆
        if (textField.secureTextEntry) {
            [self.view endEditing:YES];
            [self loginBtnClick];
            return false;
        } else {
            [self.pwdField becomeFirstResponder];
            return false;
        }
    }
    return true;
}

#pragma mark -构造方法
-(void)makeSubViews{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.nameField];
    [self.scrollView addSubview:self.pwdField];
    [self.scrollView addSubview:self.loginBtn];
    [self.scrollView addSubview:self.registerBtn];
    [self.scrollView addSubview:self.rnDemoBtn];
    [self.scrollView addSubview:self.forgetPwdBtn];
   // [self.scrollView addSubview:self.socialBtn];
    [self.scrollView addSubview:self.socialView];
    
//    [self.socialView addSubview:self.weiBtn];
//    [self.socialView addSubview:self.qqBtn];
//    [self.socialView addSubview:self.weibBtn];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    CGFloat y = 0;
    if (IS_IPHONE_4_OR_LESS) {
        y = 30;
    }
    
    self.nameField.frame=CGRectMake(40, 60.0/667*SCREEN_HEIGHT , SCREEN_WIDTH-40*2, 44);
    self.pwdField.frame=CGRectMake(40, CGRectGetMaxY(self.nameField.frame) + KSCMargin, SCREEN_WIDTH-40 * 2, 44);
    self.forgetPwdBtn.frame=CGRectMake(SCREEN_WIDTH-40-60, CGRectGetMaxY(self.pwdField.frame) + 5, 60, 16);
    self.loginBtn.frame=CGRectMake(40, CGRectGetMaxY(self.pwdField.frame) + 50, SCREEN_WIDTH - 40 * 2, 44);
    self.registerBtn.frame=CGRectMake(40, CGRectGetMaxY(self.loginBtn.frame) + KSCMargin, SCREEN_WIDTH- 40 * 2, 44);
    //    self.rnDemoBtn.frame=CGRectMake(KSCMargin, CGRectGetMaxY(self.registerBtn.frame) + KSCMargin, SCREEN_WIDTH-30, 40);
    
    
    self.socialView.frame=CGRectMake(45,SCREEN_HEIGHT-70.0/667*SCREEN_HEIGHT - IPHONE_NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 45 * 2 , 50);
    self.socialBtn.frame = CGRectMake((SCREEN_WIDTH-75)/2,CGRectGetMinY(self.socialView.frame) - 45, 75,20);
    self.weiBtn.frame=CGRectMake(0, 0, 50, 50);
    self.weibBtn.frame=CGRectMake((SCREEN_WIDTH- 50)/2-45, 0, 50, 50);
    self.qqBtn.frame=CGRectMake(self.socialView.frame.size.width - 50, 0, 50, 50);
}

- (void)loginBtnClick {
    NSString *userName = [self.nameField.text stringByTrim];
    NSString *pwd      = [self.pwdField.text stringByTrim];
    if ([userName isNotBlank]&& [pwd isNotBlank]) {
        NSString *pwdMD5 = [SCMD5Tool MD5ForLower32Bate:self.pwdField.text];
        NSTimeInterval time =(long long) [[NSDate date] timeIntervalSince1970];
        NSString *typeAppend = [@"USER_TYPE_MOBILE" stringByAppendingString:[NSString stringWithFormat:@"%.0f",time]];
        
        NSString *encryptAccount = [SCAES encryptShanChainWithPaddingString:typeAppend withContent:self.nameField.text];
        
        NSString *encryptPassword = [SCAES encryptShanChainWithPaddingString:[typeAppend stringByAppendingString:self.nameField.text] withContent:pwdMD5];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"USER_TYPE_MOBILE" forKey:@"userType"];
        [params setObject:[NSString stringWithFormat:@"%0.f",time] forKey:@"Timestamp"];
        [params setObject:encryptAccount forKey:@"encryptAccount"];
        [params setObject:encryptPassword forKey:@"encryptPassword"];
        [SYProgressHUD showMessage:@"登录中……"];
        WS(WeakSelf);
        [SCNetwork.shareInstance postWithUrl:COMMONUSERLOGIN parameters:params success:^(id responseObject) {
            NSDictionary *data = responseObject[@"data"];
            if (data[@"userInfo"] != [NSNull null]) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data[@"userInfo"]];
                [userInfo setObject:data[@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:userName forKey:K_USERNAME];
                [WeakSelf successLoginedWithContent:userInfo];
            } else {
                [SYProgressHUD showError:@"用户信息不存在"];
            }
        } failure:^(NSError *error) {
            SCLog(@"%@",error);
            [SYProgressHUD hideHUD];
            [SYProgressHUD showError:error.localizedDescription];
        }];
    }
}

- (void)successLoginedWithContent:(NSDictionary *)content {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [content[@"userId"] stringValue];
    NSString  *tk;
    if ([content[@"token"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary  *tkDic = content[@"token"];
        tk = tkDic[@"token"];
    }else{
        tk = content[@"token"];
    }
    NSString *token = [[userId stringByAppendingString:@"_"] stringByAppendingString:tk];
    
    [params setObject:[[userId stringByAppendingString:@"_"] stringByAppendingString:content[@"token"]]  forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [[SCNetwork shareInstance]postWithUrl:STORYCHARACTERGETCURRENT parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        SCCharacterModel *characterModel = [SCCharacterModel yy_modelWithDictionary:data];
        [SCCacheTool shareInstance].characterModel = characterModel;
        if (data  && data[@"characterInfo"]) {
            NSDictionary *characterInfo = data[@"characterInfo"];
            if (characterInfo[@"characterId"]) {
                //  NSString *spaceId = [characterInfo[@"spaceId"] stringValue];
                NSString *spaceId = @"";
                NSString *characterId = [characterInfo[@"characterId"] stringValue];
                NSDictionary *hxInfo = data[@"hxAccount"];
                NSString *hxUserName = hxInfo[@"hxUserName"];
                NSString *hxPassword = hxInfo[@"hxPassword"];
                [[SCAppManager shareInstance] cacheLoginUserId:userId token:token spaceId:spaceId chatacterId:characterId hxUserName:hxUserName hxPassword:hxPassword];
                [[SCCacheTool shareInstance] cacheCharacterInfo:characterInfo withUserId:userId];
                NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
                [params1 setObject:spaceId forKey:@"spaceId"];
                [params1 setObject:token forKey:@"token"];
                [[NSNotificationCenter defaultCenter]postNotificationName:kLoginSuccess object:nil];
                [JGUserLoginService jg_userLoginWithUsername:characterModel.hxAccount.hxUserName password:characterModel.hxAccount.hxPassword loginComplete:^(id _Nonnull result, NSError * _Nonnull error) {
                    [SYProgressHUD hideHUD];
                    if (!error) {
                        // 登录成功
                        UIViewController *rootVc = nil;
                        BMKTestLocationViewController  *locationVC = [[BMKTestLocationViewController alloc]init];
                        rootVc = [[JCNavigationController alloc]initWithRootViewController:locationVC];
                        //                    SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
                        [HHTool mainWindow].rootViewController=rootVc;
                    }
                }];
                
                
                //                [[SCNetwork shareInstance]postWithUrl:GET_SPACE_BY_ID parameters:params1 success:^(id responseObject) {
                //                    NSDictionary *data = responseObject[@"data"];
                //                    NSString *spaceInfo = @"";
                //                    NSString *spaceName = @"";
                //                    spaceName = data[@"name"];
                //                    spaceInfo = [JsonTool stringFromDictionary:data];
                //                    if(![spaceInfo isEqualToString:@""]){
                //                        [[SCCacheTool shareInstance] setCacheValue:spaceName withUserID:userId andKey:CACHE_SPACE_NAME];
                //                        [[SCCacheTool shareInstance] setCacheValue:spaceInfo withUserID:userId andKey:CACHE_SPACE_INFO];
                //                    }
                //                    [SYProgressHUD hideHUD];
                //
                //                } failure:^(NSError *error) {
                //                    SCLog(@"%@",error);
                //                    [SYProgressHUD hideHUD];
                //                    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                //                    SCTabbarController *tabbarC=[[SCTabbarController alloc]init];
                //                    keyWindow.rootViewController=tabbarC;
                //                }];
            } else {
                [SYProgressHUD hideHUD];
            }
        } else {
            [HHTool showError:@"登录出错..."];
            //            [[SCAppManager shareInstance] cacheLoginUserId:userId token:token spaceId:@"" chatacterId:@"" hxUserName:@"" hxPassword:@""];
            //            UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
            //            SYStoryMarkController *vc=[[SYStoryMarkController alloc] init];
            //            SCBaseNavigationController *nav = [[SCBaseNavigationController alloc] initWithRootViewController: vc];
            //            keyWindow.rootViewController = nav;
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
        [SYProgressHUD hideHUD];
    }];
}

-(void)registerBtnClicked{
    SCPhoneRegisterController *phoneRegsiterVC=[[SCPhoneRegisterController alloc]init];
    [self.navigationController pushViewController:phoneRegsiterVC animated:YES];
}

-(void)rnBtnClicked{
    NSURL *jsCodeLocation;
    
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"App"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = rootView;
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void)forgetPwdBtnClick{
    SCInitPasswordController *forgetPwdVC=[[SCInitPasswordController alloc]init];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

//- (void)keyboardDidShow:(NSNotification*)notification {
//    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
//    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    // 第三方键盘回调三次问题，监听仅执行最后一次
//    if ( begin.size.height>0 && (begin.origin.y-end.origin.y>0) ) {
//        if (_keyboardIsShown) {
//            return ;
//        }
//        NSDictionary *userInfo = [notification userInfo];
//        CGFloat h = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,0);
//        WS(weakSelf);
//        [Util commonViewAnimation:^{
//            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
//        }
//                       completion:nil];
//
//        _keyboardIsShown = YES;
//    }
//}
//
//- (void)keyboardDidHide:(NSNotification *)notification {
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,0);
//    WS(weakSelf);
//    [Util commonViewAnimation:^{
//        weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
//    } completion:nil];
//
//    _keyboardIsShown = NO;
//}

- (void)weiXinLoginBtnClick{
    [self thirdLoginClickWithPlatformType:SSDKPlatformTypeWechat];
}

- (void)qqLoginBtnClick{
    [self thirdLoginClickWithPlatformType:SSDKPlatformTypeQQ];
}

- (void)weiBLoginBtnClick{
    [self thirdLoginClickWithPlatformType:SSDKPlatformTypeSinaWeibo];
}

- (void)thirdLoginClickWithPlatformType:(SSDKPlatformType)type {
    [SYProgressHUD showMessage:@"登录中……"];
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error){
        if (state == SSDKResponseStateSuccess) {
            NSString *pwd = [user.credential.token substringToIndex:16];
            NSString *pwdMD5 = [SCMD5Tool MD5ForLower32Bate:pwd];
            NSString *loginTypeStr = @"USER_TYPE_QQ";
            switch (type) {
                case SSDKPlatformTypeQQ:
                    loginTypeStr = @"USER_TYPE_QQ";
                    break;
                case SSDKPlatformTypeWechat:
                    loginTypeStr = @"USER_TYPE_WEIXIN";
                    break;
                case SSDKPlatformTypeSinaWeibo:
                    loginTypeStr = @"USER_TYPE_WEIBO";
                    break;
            }
            
            NSTimeInterval time =(long long) [[NSDate date] timeIntervalSince1970];
            NSString *typeAppend = [loginTypeStr stringByAppendingString:[NSString stringWithFormat:@"%.0f",time]];
            NSString *encryptAccount = [SCAES encryptShanChainWithPaddingString:typeAppend withContent:user.uid];
            
            NSString *encryptPassword = [SCAES encryptShanChainWithPaddingString:[typeAppend stringByAppendingString:user.uid] withContent:pwdMD5];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:user.nickname forKey:@"nickName"];
            [params setObject:loginTypeStr forKey:@"userType"];
            [params setObject:user.icon forKey:@"headIcon"];
            
            [params setObject:[NSString stringWithFormat:@"%ld",(long)user.gender] forKey:@"sex"];
            [params setObject:[NSString stringWithFormat:@"%0.f",time] forKey:@"Timestamp"];
            
            [params setObject:encryptAccount forKey:@"encryptOpenId"];
            [params setObject:encryptPassword forKey:@"encryptToken16"];
            WS(WeakSelf);
            [SYProgressHUD hideHUD];
            [[SCNetwork shareInstance]postWithUrl:COMMONUSERLOGINTHIRD parameters:params success:^(id responseObject) {
                [SYProgressHUD showSuccess:@"正在获取数据"];
                NSDictionary *data = responseObject[@"data"];
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data[@"userInfo"]];
                [userInfo setObject:data[@"token"] forKey:@"token"];
                [WeakSelf successLoginedWithContent:userInfo];
            } failure:nil];
        } else {
            SCLog(@"%@",error);
            [SYProgressHUD showError:@"三方登陆失败"];
            [SYProgressHUD hideHUD];
        }
    }];
}

@end
