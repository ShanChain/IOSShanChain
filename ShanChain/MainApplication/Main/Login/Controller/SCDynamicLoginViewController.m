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


@end

@implementation SCDynamicLoginViewController


- (void)setUI{
    
    if (self.loginType == LoginType_bindPhoneNumber) {
        self.stackView.hidden = YES;
        self.titleLb.hidden = YES;
        self.line1.hidden = YES;
        self.line2.hidden = YES;
    }
    [self.loginBtn setTitle:self.loginType == LoginType_bindPhoneNumber? @"确定":@"登录" forState:0];
    [self.QQBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.weiboBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self.wechatBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    
    [[self.getVerifyCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.phoneNumberFid.text.length == 0) {
            [HHTool showError:@"手机号不能为空"];
            return ;
        }
        if (![self.phoneNumberFid.text isValidPhoneNumber]) {
            [HHTool showError:@"请输入的手机号有误"];
            return ;
        }
        
        [self.getVerifyCodeBtn startWithTime:59 title:@"重新获取" countDownTitle:@"s" mainColor:Theme_MainTextColor countColor:Theme_MainThemeColor];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"动态验证码登录";
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
  
}
- (IBAction)QQLoginAction:(UIButton *)sender {
    [self otherLoginWithPlatfrom:JSHAREPlatformQQ];
}

- (IBAction)weiboLoginAction:(UIButton *)sender {
    [self otherLoginWithPlatfrom:JSHAREPlatformSinaWeibo];
}

- (IBAction)wechatLoginAction:(UIButton *)sender {
    [self otherLoginWithPlatfrom:JSHAREPlatformWechatSession];
}

- (void)otherLoginWithPlatfrom:(JSHAREPlatform)platfrom{
    [JSHAREService getSocialUserInfo:platfrom handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        NSString *alertMessage;
        NSString *title;
        if (error) {
            title = @"失败";
            alertMessage = @"无法获取到用户信息";
        }else{
            title = userInfo.name;
            alertMessage = [NSString stringWithFormat:@"昵称: %@\n 头像链接: %@\n 性别: %@\n",userInfo.name,userInfo.iconurl,userInfo.gender == 1? @"男" : @"女"];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Alert show];
        });
    }];
}

@end
