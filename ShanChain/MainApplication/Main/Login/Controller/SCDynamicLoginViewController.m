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

@end

@implementation SCDynamicLoginViewController


- (NSDictionary*)getParameter{
    
    NSMutableString  *mStr = [[NSMutableString alloc]init];
    [mStr appendString:self.verifyCodeFid.text];
    [mStr appendString:self.verifyCodeModel.salt];
    [mStr appendString:self.verifyCodeModel.timestamp];
    NSString *sign = [SCMD5Tool MD5ForUpper32Bate:mStr.copy];
    if (!NULLString(self.encryptOpenId)) {
        return  @{@"encryptOpenId":self.encryptOpenId,@"mobile":self.phoneNumberFid.text,@"sign":sign,@"verifyCode":self.verifyCodeFid.text};
    }
    return @{@"mobile":self.phoneNumberFid.text,@"sign":sign,@"verifyCode":self.verifyCodeFid.text};
}


- (void)setUI{
    
    if (self.loginType == LoginType_bindPhoneNumber) {
        self.stackView.hidden = YES;
        self.titleLb.hidden = YES;
        self.line1.hidden = YES;
        self.line2.hidden = YES;
        self.title = @"关联手机号";
    }else{
        self.title = @"动态验证码登录";
    }
    [self.loginBtn setTitle:self.loginType == LoginType_bindPhoneNumber? @"确定":@"登录" forState:0];
    [self.QQBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.weiboBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.wechatBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    WEAKSELF
    [[self.getVerifyCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (weakSelf.phoneNumberFid.text.length == 0) {
            [HHTool showError:@"手机号不能为空"];
            return ;
        }
        if (![weakSelf.phoneNumberFid.text isValidPhoneNumber]) {
            [HHTool showError:@"请输入的手机号有误"];
            return ;
        }
        [[SCNetwork shareInstance] v1_postWithUrl:Verifycode_URL params:@{@"mobile":weakSelf.phoneNumberFid.text} showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
            if (!baseModel.data && error) {
                return ;
            }
            
            weakSelf.verifyCodeModel = [VerifyCodeModel yy_modelWithDictionary:baseModel.data];
            [weakSelf.getVerifyCodeBtn startWithTime:59 title:@"重新获取" countDownTitle:@"s" mainColor:Theme_MainTextColor countColor:Theme_MainThemeColor];
            
        }];
    }];
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
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:data[@"userInfo"]];
        [userInfo setObject:data[@"token"] forKey:@"token"];
        [SCLoginDataController successLoginedWithContent:userInfo];
    }];
    
}
- (IBAction)QQLoginAction:(UIButton *)sender {
  
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformQQ bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
        [self bindPhoneNumberWithEncryptOpenId:encryptOpenId];
    }];
}

- (IBAction)weiboLoginAction:(UIButton *)sender {
    
    [SCLoginDataController otherLoginWithPlatfrom:JSHAREPlatformSinaWeibo bindPhoneNumberCallBack:^(NSString *encryptOpenId) {
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
