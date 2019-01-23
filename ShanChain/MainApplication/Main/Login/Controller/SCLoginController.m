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
#import "SCCacheTool.h"
#import "SCBaseNavigationController.h"
#import "BMKTestLocationViewController.h"
#import "SCCharacterModel.h"
#import "SCDynamicLoginViewController.h"
#import "SCLoginDataController.h"

#define K_USERNAME @"K_USERNAME"

@interface SCLoginController ()<UITextFieldDelegate>{
    BOOL _keyboardIsShown;
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UITextField   *nameField;
@property (nonatomic, strong) UITextField   *pwdField;
@property (nonatomic, strong) UIButton      *forgetPwdBtn;

@property (nonatomic, strong) UIButton      *loginBtn;
@property (nonatomic, strong) UIButton      *dynamicLoginBtn;//动态密码登录
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
        _nameField = [SYUIFactory textFieldWithPlacehold:NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil) withFont:[UIFont systemFontOfSize:14] withColor:[UIColor blackColor]];
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
        _pwdField = [SYUIFactory textFieldWithPlacehold:NSLocalizedString(@"sc_login_pleaseEnterPassword", nil) withFont:[UIFont systemFontOfSize:14] withColor:[UIColor blackColor]];
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
        [_forgetPwdBtn setTitle:NSLocalizedString(@"sc_login_forgetPassword", nil) forState:UIControlStateNormal];
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
        [_loginBtn setTitle:NSLocalizedString(@"sc_login_Login", nil) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.backgroundColor = Theme_MainThemeColor;
        ViewRadius(_loginBtn, 8);
    }
    return _loginBtn;
}


- (UIButton *)dynamicLoginBtn{
    if (!_dynamicLoginBtn) {
        _dynamicLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dynamicLoginBtn setTitle:NSLocalizedString(@"sc_login_SMSLogIn", nil) forState:UIControlStateNormal];
        [_dynamicLoginBtn setTitleColor:Theme_MainThemeColor forState:UIControlStateNormal];
        _dynamicLoginBtn.titleLabel.textAlignment = 0;
        _dynamicLoginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_dynamicLoginBtn addTarget:self action:@selector(dynamicLoginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dynamicLoginBtn;
}

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:NSLocalizedString(@"sc_login_SignUp", nil) forState:UIControlStateNormal];
        [_registerBtn setTitleColor:Theme_MainThemeColor forState:UIControlStateNormal];
        [_registerBtn makeLayerWithRadius:8.0f withBorderColor:Theme_MainThemeColor withBorderWidth:1.0f];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registerBtn addTarget:self action:@selector(registerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

-(UIButton *)socialBtn{
    if (!_socialBtn) {
        _socialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_socialBtn setTitle:NSLocalizedString(@"sc_login_others", nil) forState:UIControlStateNormal];
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
    
    self.title = NSLocalizedString(@"sc_login_LogInMJ", nil);
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
    [self.scrollView addSubview:self.dynamicLoginBtn];
    [self.scrollView addSubview:self.registerBtn];
    [self.scrollView addSubview:self.rnDemoBtn];
    [self.scrollView addSubview:self.forgetPwdBtn];
    [self.scrollView addSubview:self.socialBtn];
    [self.scrollView addSubview:self.socialView];
    
    [self.socialView addSubview:self.weiBtn];
    [self.socialView addSubview:self.qqBtn];
    [self.socialView addSubview:self.weibBtn];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    CGFloat y = 0;
    if (IS_IPHONE_4_OR_LESS) {
        y = 30;
    }
    
    self.nameField.frame=CGRectMake(40, 60.0/667*SCREEN_HEIGHT , SCREEN_WIDTH-40*2, 44);
    self.pwdField.frame=CGRectMake(40, CGRectGetMaxY(self.nameField.frame) + KSCMargin, SCREEN_WIDTH-40 * 2, 44);
    self.forgetPwdBtn.frame=CGRectMake(SCREEN_WIDTH-40-60, CGRectGetMaxY(self.pwdField.frame) + 5, 100, 16);
    self.dynamicLoginBtn.frame = CGRectMake(40, CGRectGetMaxY(self.pwdField.frame) + 50, 100, 25);
    self.loginBtn.frame=CGRectMake(40, CGRectGetMaxY(self.pwdField.frame) + 80, SCREEN_WIDTH - 40 * 2, 44);
    self.registerBtn.frame=CGRectMake(40, CGRectGetMaxY(self.loginBtn.frame) + KSCMargin, SCREEN_WIDTH- 40 * 2, 44);
    //    self.rnDemoBtn.frame=CGRectMake(KSCMargin, CGRectGetMaxY(self.registerBtn.frame) + KSCMargin, SCREEN_WIDTH-30, 40);
    
    
   self.socialView.frame=CGRectMake(45,SCREEN_HEIGHT-70.0/667*SCREEN_HEIGHT - IPHONE_NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH - 45 * 2 , 50);
    self.socialBtn.frame = CGRectMake((SCREEN_WIDTH-75)/2,CGRectGetMinY(self.socialView.frame) - 45, 75,20);
    self.weiBtn.frame=CGRectMake(0, 0, 50, 50);
    self.weibBtn.frame=CGRectMake((SCREEN_WIDTH- 50)/2-45, 0, 50, 50);
    self.qqBtn.frame=CGRectMake(self.socialView.frame.size.width - 50, 0, 50, 50);
}

- (void)dynamicLoginClick{
    SCDynamicLoginViewController *vc = [[SCDynamicLoginViewController alloc]init];
    vc.loginType = LoginType_dynamic;
    [self.navigationController pushViewController:vc animated:YES];
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
        [params setObject:SC_APP_CHANNEL forKey:@"channel"];
        [SYProgressHUD showMessage:NSLocalizedString(@"sc_login_loggingIn", nil)];
        [SCNetwork.shareInstance postWithUrl:COMMONUSERLOGIN parameters:params success:^(id responseObject) {
            NSDictionary *data = responseObject[@"data"];
            if (data[@"userInfo"] != [NSNull null]) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data[@"userInfo"]];
                [userInfo setObject:data[@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:userName forKey:K_USERNAME];
                [SCLoginDataController successLoginedWithContent:userInfo];
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



-(void)registerBtnClicked{
    SCPhoneRegisterController *phoneRegsiterVC=[[SCPhoneRegisterController alloc]init];
    [self.navigationController pushViewController:phoneRegsiterVC animated:YES];
}

//-(void)rnBtnClicked{
//    NSURL *jsCodeLocation;
//    
//    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
//    
//    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
//                                                        moduleName:@"App"
//                                                 initialProperties:nil
//                                                     launchOptions:nil];
//    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view = rootView;
//    [self presentViewController:vc animated:YES completion:nil];
//    
//}
-(void)forgetPwdBtnClick{
    SCInitPasswordController *forgetPwdVC=[[SCInitPasswordController alloc]init];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}


- (void)weiXinLoginBtnClick{
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformWechatSession bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
        [self bindPhoneNumberWithEncryptOpenId:encryptOpenId];
    }];
    
    
}

- (void)qqLoginBtnClick{
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformQQ bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
        [self bindPhoneNumberWithEncryptOpenId:encryptOpenId];
    }];
}

- (void)weiBLoginBtnClick{
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformSinaWeibo bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
        [self bindPhoneNumberWithEncryptOpenId:encryptOpenId];
    }];
}

// 绑定手机号
- (void)bindPhoneNumberWithEncryptOpenId:(NSString*)encryptOpenId{
    SCDynamicLoginViewController *vc = [[SCDynamicLoginViewController alloc]init];
    vc.loginType = LoginType_bindPhoneNumber;
    vc.encryptOpenId = encryptOpenId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)thirdLoginClickWithPlatformType:(SSDKPlatformType)type {
    [SYProgressHUD showMessage:NSLocalizedString(@"sc_login_loggingIn", nil)];
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
                default: ;
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
            [params setObject:SC_APP_CHANNEL forKey:@"channel"];
            [SYProgressHUD hideHUD];
            [[SCNetwork shareInstance]postWithUrl:COMMONUSERLOGINTHIRD parameters:params success:^(id responseObject) {
                [SYProgressHUD showSuccess:@"正在获取数据"];
                NSDictionary *data = responseObject[@"data"];
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data[@"userInfo"]];
                [userInfo setObject:data[@"token"] forKey:@"token"];
                [SCLoginDataController successLoginedWithContent:userInfo];
            } failure:nil];
        } else {
            SCLog(@"%@",error);
            [SYProgressHUD showError:@"三方登陆失败"];
            [SYProgressHUD hideHUD];
        }
    }];
}

@end
