//
//  SCDynamicLoginViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/11.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "SCDynamicLoginViewController.h"
#import "UIButton+EnlargeTouchArea.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "JPUSHService.h"
#import "JSHAREService.h"
#import "VerifyCodeModel.h"
#import "SCLoginDataController.h"
#import "WXApi.h"
#import "WeiboSDK.h"



// 节点结构
typedef struct _node {
    int val;
    struct _node *next;
}Node;

typedef struct _stack {
    int length;
    struct _node *top;
}StackList;

@interface SCDynamicLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberFid;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeFid;

@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;

@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property  (nonatomic,strong) VerifyCodeModel  *verifyCodeModel;

@property (weak, nonatomic) IBOutlet UIView *weiboView;
@property (weak, nonatomic) IBOutlet UIView *wxView;

@property (weak, nonatomic) IBOutlet UIView *qqView;

@end


@implementation SCDynamicLoginViewController



- (NSDictionary*)getParameter{
    
    NSMutableString  *mStr = [[NSMutableString alloc]init];
    [mStr appendString:self.verifyCodeFid.text];
    [mStr appendString:self.verifyCodeModel.salt];
    [mStr appendString:self.verifyCodeModel.timestamp];
    NSString *sign = [SCMD5Tool MD5ForUpper32Bate:mStr.copy];
    NSString  *deviceToken = [JPUSHService registrationID];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (!NULLString(deviceToken)) {
        deviceToken = @"";
    }
    if (!NULLString(self.encryptOpenId)) {
        return  @{@"encryptOpenId":self.encryptOpenId,@"mobile":self.phoneNumberFid.text,@"sign":sign,@"verifyCode":self.verifyCodeFid.text,@"channel":SC_APP_CHANNEL,@"deviceToken":deviceToken,@"version":version};
    }
    return @{@"mobile":self.phoneNumberFid.text,@"sign":sign,@"verifyCode":self.verifyCodeFid.text,@"channel":SC_APP_CHANNEL,@"deviceToken":deviceToken,@"version":version};
}


- (void)setUI{
    
    self.phoneNumberFid.placeholder = NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil);
    self.titleLb.text = NSLocalizedString(@"sc_login_others", nil);
    [self.getVerifyCodeBtn setTitle:NSLocalizedString(@"sc_login_Send", nil) forState:0];
    
    if (self.loginType == LoginType_bindPhoneNumber) {
        self.stackView.hidden = YES;
        self.titleLb.hidden = YES;
        self.line1.hidden = YES;
        self.line2.hidden = YES;
        self.title = NSLocalizedString(@"sc_login_Bind", nil);
    }else{
        self.title = NSLocalizedString(@"sc_login_useSMS", nil);
    }
    [self.loginBtn setTitle:self.loginType == LoginType_bindPhoneNumber? @"确定":NSLocalizedString(@"sc_login_Login", nil) forState:0];
    [self.QQBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.weiboBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.wechatBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    WEAKSELF
    [[self.getVerifyCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakSelf.phoneNumberFid.text.length == 0) {
            [HHTool showError:NSLocalizedString(@"sc_login_phoneNumberCannotEmpty", nil)];
            return ;
        }
        if (![weakSelf.phoneNumberFid.text isValidPhoneNumber]) {
            [HHTool showError:NSLocalizedString(@"sc_login_wrongphonenumber", nil)];
            return ;
        }
        [[SCNetwork shareInstance] v1_postWithUrl:Verifycode_URL params:@{@"mobile":weakSelf.phoneNumberFid.text} showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
            if (!baseModel.data && error) {
                return ;
            }
            
            weakSelf.verifyCodeModel = [VerifyCodeModel yy_modelWithDictionary:baseModel.data];
            [weakSelf.getVerifyCodeBtn startWithTime:59 title:NSLocalizedString(@"sc_login_Resend", nil) countDownTitle:@"s" mainColor:Theme_MainTextColor countColor:Theme_MainThemeColor];
            
        }];
    }];
    
    BOOL qq = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqqapi://"]];
    if (!qq) {
        [_stackView removeArrangedSubview:self.qqView];
        [self.qqView removeFromSuperview];
    }
    
    BOOL weixin = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]];
    if (!weixin) {
         [_stackView removeArrangedSubview:self.wxView];
         [self.wxView removeFromSuperview];
    }
    
//    BOOL weibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]];
    
    BOOL facebook = [JSHAREService isFacebookInstalled];
    
    
    if (!facebook) {
        [_stackView removeArrangedSubview:self.weiboView];
        [self.weiboView removeFromSuperview];
    }
    
    if (!qq && !weixin && !facebook) {
        self.titleLb.hidden = YES;
        self.line1.hidden = YES;
        self.line2.hidden = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[self.phoneNumberFid.rac_textSignal,self.verifyCodeFid.rac_textSignal] reduce:^id _Nullable(NSString *phone , NSString *code){
        return @(phone.length == 11 && code.length > 0);
    }];
    
    RAC(self.phoneNumberFid,text) = [RACSignal combineLatest:@[self.phoneNumberFid.rac_textSignal] reduce:^id _Nullable(NSString *phone){
        if (phone.length > 11) {
            return  [phone substringToIndex:11];
        }
        return phone;
    }];
    
    RAC(self.loginBtn,backgroundColor) = [RACSignal combineLatest:@[self.phoneNumberFid.rac_textSignal,self.verifyCodeFid.rac_textSignal] reduce:^id _Nullable(NSString *phone , NSString *code){
        return self.loginBtn.enabled ? Theme_MainThemeColor:[UIColor lightGrayColor];
    }];
    RAC(self.getVerifyCodeBtn,titleLabel.textColor) = [RACSignal combineLatest:@[self.phoneNumberFid.rac_textSignal] reduce:^id _Nullable(NSString * phone){
        return @(phone.length == 11).boolValue ? Theme_MainTextColor:[UIColor colorWithString:@"BBBBBB"];
    }];
    
}

- (IBAction)passwordLoginAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    [[SCNetwork shareInstance]v1_postWithUrl:Sms_login_URL params:[self getParameter] showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (error) {
            return ;
        }
        NSDictionary *data = (NSDictionary*)baseModel.data;
        if (!data) {
            return;
        }
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data[@"userInfo"]];
        if (data[@"token"] && [data[@"token"] isKindOfClass:[NSString class]]) {
            [userInfo setObject:data[@"token"] forKey:@"token"];
        }
        [SCLoginDataController successLoginedWithContent:userInfo];
    }];
    
}
- (IBAction)QQLoginAction:(UIButton *)sender {
  
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformQQ bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
        [self bindPhoneNumberWithEncryptOpenId:encryptOpenId];
    }];
}

- (IBAction)weiboLoginAction:(UIButton *)sender {
    
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformFacebook bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
        [self bindPhoneNumberWithEncryptOpenId:encryptOpenId];
    }];
}

- (IBAction)wechatLoginAction:(UIButton *)sender {
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformWechatSession bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
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

@end
