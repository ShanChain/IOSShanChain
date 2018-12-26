//
//  SCPhoneRegisterController.m
//  ShanChain
//
//  Created by krew on 2017/5/18.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCPhoneRegisterController.h"
#import "SCAES.h"
#import "NSString+URL.h"

@interface SCPhoneRegisterController ()<UITextFieldDelegate>{
    BOOL _keyboardIsShown;
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UITextField   *phoneValueFiled;
@property (nonatomic, strong) UITextField   *verCodeValueFiled;
@property (nonatomic, strong) UIButton      *verCodeBtn;
@property (nonatomic, strong) UITextField   *pwdField;
@property (nonatomic, strong) UITextField   *pwdSureField;
@property (nonatomic, strong) UIButton      *sureBtn;
@property (nonatomic, strong) UIButton      *serviceBtn;
@property (nonatomic, assign) CGFloat       scrollViewContentHeight;
@property (nonatomic, assign) CGFloat       currOffsetY;

@property(nonatomic, copy)NSString  *verCodeString;

@end

@implementation SCPhoneRegisterController
#pragma mark -懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UITextField *)phoneValueFiled{
    if (!_phoneValueFiled) {
        _phoneValueFiled=[UITextField new];
        _phoneValueFiled.placeholder = NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil);
        _phoneValueFiled.font=[UIFont systemFontOfSize:14];
        _phoneValueFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
        _phoneValueFiled.textAlignment=NSTextAlignmentLeft;
        _phoneValueFiled.layer.masksToBounds = YES;
        _phoneValueFiled.layer.cornerRadius = 8.0f;
        _phoneValueFiled.layer.borderWidth = 1.0;
        _phoneValueFiled.keyboardType = UIKeyboardTypeNumberPad;
        _phoneValueFiled.layer.borderColor = [RGB(221, 221, 221)CGColor];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _phoneValueFiled.leftView = leftView;
        _phoneValueFiled.leftViewMode = UITextFieldViewModeAlways;
        [_phoneValueFiled setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
        [_phoneValueFiled setValue:RGB(221, 221, 221) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneValueFiled.delegate = self;
    }
    return _phoneValueFiled;
}

-(UITextField *)verCodeValueFiled{
    if (!_verCodeValueFiled) {
        _verCodeValueFiled=[UITextField new];
        _verCodeValueFiled.placeholder=@"请输入验证码";
        _verCodeValueFiled.font=[UIFont systemFontOfSize:14];
        _verCodeValueFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
        _verCodeValueFiled.textAlignment=NSTextAlignmentLeft;
        _verCodeValueFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _verCodeValueFiled.keyboardType = UIKeyboardTypeNumberPad;
        _verCodeValueFiled.layer.masksToBounds = YES;
        _verCodeValueFiled.layer.cornerRadius = 8.0f;
        _verCodeValueFiled.layer.borderWidth = 1.0;
        _verCodeValueFiled.layer.borderColor = [RGB(221, 221, 221)CGColor];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _verCodeValueFiled.leftView = leftView;
        _verCodeValueFiled.leftViewMode = UITextFieldViewModeAlways;
        [_verCodeValueFiled setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
        [_verCodeValueFiled setValue:RGB(221, 221, 221) forKeyPath:@"_placeholderLabel.textColor"];
        _verCodeValueFiled.delegate = self;
    }
    return _verCodeValueFiled;
}

-(UIButton *)verCodeBtn{
    if (!_verCodeBtn) {
        _verCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verCodeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _verCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_verCodeBtn addTarget:self action:@selector(getVerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verCodeBtn;
}

-(UITextField *)pwdField{
    if (!_pwdField) {
        _pwdField=[UITextField new];
        _pwdField.placeholder=@"请输入密码(至少6位)";
        _pwdField.font=[UIFont systemFontOfSize:14];
        _pwdField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _pwdField.secureTextEntry=YES;
        _pwdField.textAlignment=NSTextAlignmentLeft;
        _pwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _pwdField.layer.masksToBounds = YES;
        _pwdField.layer.cornerRadius = 8.0f;
        _pwdField.layer.borderWidth = 1.0;
        _pwdField.layer.borderColor = [RGB(221, 221, 221)CGColor];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _pwdField.leftView = leftView;
        _pwdField.leftViewMode = UITextFieldViewModeAlways;
        [_pwdField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
        [_pwdField setValue:RGB(221, 221, 221) forKeyPath:@"_placeholderLabel.textColor"];
        _pwdField.delegate = self;
    }
    return _pwdField;
}

-(UITextField *)pwdSureField{
    if (!_pwdSureField) {
        _pwdSureField=[UITextField new];
        _pwdSureField.placeholder=@"请再次输入密码(至少6位)";
        _pwdSureField.font=[UIFont systemFontOfSize:14];
        _pwdSureField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _pwdSureField.secureTextEntry=YES;
        _pwdSureField.textAlignment=NSTextAlignmentLeft;
        _pwdSureField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _pwdSureField.layer.masksToBounds = YES;
        _pwdSureField.layer.cornerRadius = 8.0f;
        _pwdSureField.layer.borderWidth = 1.0;
        _pwdSureField.layer.borderColor = [RGB(221, 221, 221)CGColor];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _pwdSureField.leftView = leftView;
        _pwdSureField.leftViewMode = UITextFieldViewModeAlways;
        [_pwdSureField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
        [_pwdSureField setValue:RGB(221, 221, 221) forKeyPath:@"_placeholderLabel.textColor"];
        _pwdSureField.delegate = self;
    }
    return _pwdSureField;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"同意服务条款并注册" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = Theme_MainThemeColor;
        ViewRadius(_sureBtn, 8);
    }
    return _sureBtn;
}

-(UIButton *)serviceBtn{
    if (!_serviceBtn) {
        _serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_serviceBtn setTitle:@"《千千世界服务条款》" forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:Theme_MainThemeColor forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_serviceBtn addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBtn;
}

#pragma mark -系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:self.view.window];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=RGB(255, 255, 255);
    self.title=NSLocalizedString(@"sc_login_SignUp", nil);
    [self makeSubViews];
    [self setKeyBoardAutoHidden];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark-构造方法
-(void)makeSubViews{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.phoneValueFiled];
    [self.scrollView addSubview:self.verCodeValueFiled];
    [self.scrollView addSubview:self.verCodeBtn];
    [self.scrollView addSubview:self.pwdSureField];
    [self.scrollView addSubview:self.pwdField];
    [self.scrollView addSubview:self.sureBtn];
    [self.scrollView addSubview:self.serviceBtn];
    
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat y = 0;
    if (IS_IPHONE_4_OR_LESS) {
        y = 30;
    }
    self.scrollViewContentHeight = SCREEN_HEIGHT;
    self.phoneValueFiled.frame=CGRectMake(40, 60, SCREEN_WIDTH - 2* 40, 44);
    self.verCodeValueFiled.frame=CGRectMake(40, CGRectGetMaxY(self.phoneValueFiled.frame) + KSCMargin, SCREEN_WIDTH - 2 * 40, 44);
    self.verCodeBtn.frame=CGRectMake(CGRectGetMaxX(self.verCodeValueFiled.frame) - 100, CGRectGetMaxY(self.phoneValueFiled.frame) + KSCMargin + 12, 100, 20);
    self.pwdField.frame=CGRectMake(40, CGRectGetMaxY(self.verCodeValueFiled.frame) + KSCMargin,SCREEN_WIDTH-40 * 2, 44);
    self.pwdSureField.frame=CGRectMake(40, CGRectGetMaxY(self.pwdField.frame) + KSCMargin, SCREEN_WIDTH - 2* 40, 44);
    self.sureBtn.frame=CGRectMake(40, CGRectGetMaxY(self.pwdSureField.frame) + 30,  SCREEN_WIDTH-2 * 40, 44);
    self.serviceBtn.frame=CGRectMake(100, CGRectGetMaxY(self.sureBtn.frame) + 20, SCREEN_WIDTH-100 * 2, 12);
    
}

-(void)getVerCodeAction{
 //   [self isMobilePhone:self.phoneValueFiled.text];
    if ([self.phoneValueFiled.text length]!=0) {
        if ([self.phoneValueFiled becomeFirstResponder]) {
            __block NSInteger time = 59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(time <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置按钮的样式
                        [self.verCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                        [self.verCodeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
                        self.verCodeBtn.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = time % 60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置按钮显示读秒效果
                        [self.verCodeBtn setTitle:[NSString stringWithFormat:@"(%.2d)", seconds] forState:UIControlStateNormal];
                        [self.verCodeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
                        self.verCodeBtn.userInteractionEnabled = NO;
                    });
                    time--;
                }
            });
            dispatch_resume(_timer);  
        }
    }else{
        [SYProgressHUD showError:NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil)];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneValueFiled.text forKey:@"mobile"];
    
    [[SCNetwork shareInstance]postWithUrl:COMMONSMSUNLOGINVERIFYCODE parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
            NSDictionary *data = responseObject[@"data"];
            self.verCodeString = data[@"smsVerifyCode"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//验证手机号码
-(BOOL)isMobilePhone:(NSString *)phoneNum
{
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:phoneNum]) {
        return YES;
        
    }else{
        [SYProgressHUD showError:@"输入的手机号有误"];
        return NO;
    }
    
}

- (void)serviceAction {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"http://www.qianqianshijie.com/#/agreement"]];
}

-(void)sureAction{
    if ([self.phoneValueFiled.text length]==0) {
        [SYProgressHUD showError:NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil)];
        return;
    }
    if ([self.verCodeValueFiled.text length]!=0) {
        if (![self.verCodeValueFiled.text isEqualToString:self.verCodeString]) {
            [SYProgressHUD showError:@"验证码输入有误，请重新查看"];
            return;
        }
    }else{
        [SYProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if ([self.pwdField.text length] != 0) {
        if (self.pwdSureField.text.length >= 6 && self.pwdSureField.text.length <= 16) {
            if ([self.pwdSureField.text isEqualToString:self.pwdField.text]) {
                NSString *pwdMD5 = [SCMD5Tool MD5ForLower32Bate:self.pwdField.text];
                NSTimeInterval time =(long long) [[NSDate date] timeIntervalSince1970];
                NSString *typeAppend = [@"USER_TYPE_MOBILE" stringByAppendingString:[NSString stringWithFormat:@"%.0f",time]];
                NSString *baseEncodeString = [SCBase64 encodeBase64String:typeAppend];
                NSString *subString = [baseEncodeString substringToIndex:16];
                NSString *cipherText = [SCAES encryptAES:self.phoneValueFiled.text key:subString];
                NSString *urlString = [cipherText URLEncodedString];
                NSString *encryptAccount = [SCBase64 encodeBase64String:urlString];
                
                NSString *pwdTypeAppend = [typeAppend stringByAppendingString:self.phoneValueFiled.text];
                NSString *baseString = [SCBase64 encodeBase64String:pwdTypeAppend];
                NSString *subString1 = [baseString substringToIndex:16];
                NSString *cipherText1 = [SCAES encryptAES:pwdMD5 key:subString1];
                NSString *urlString1 = [cipherText1 URLEncodedString];
                NSString *encryptAccount1 = [SCBase64 encodeBase64String:urlString1];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:@"USER_TYPE_MOBILE" forKey:@"userType"];
                [params setObject:[NSString stringWithFormat:@"%0.f",time] forKey:@"Timestamp"];
                [params setObject:encryptAccount forKey:@"encryptAccount"];
                [params setObject:encryptAccount1 forKey:@"encryptPassword"];
                
                [HHTool showChrysanthemum];
                [[SCNetwork shareInstance]postWithUrl:COMMONUSERREGISTER parameters:params success:^(id responseObject) {
                    [HHTool dismiss];
                    [SYProgressHUD showSuccess:@"注册成功"];
                    
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:nil];
            } else {
                [SYProgressHUD showError:@"两次输入密码不一致，请重新输入"];
                [self.pwdSureField becomeFirstResponder];
            }
        } else {
            [SYProgressHUD showError:@"密码长度为6-16个字符"];
            [self.pwdSureField becomeFirstResponder];
        }
    } else {
        [SYProgressHUD showError:@"密码不能为空!"];
        [self.pwdSureField becomeFirstResponder];
    }


}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return textField.text.length + string.length;
}

- (void)keyboardDidShow:(NSNotification*)notification {
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if ( begin.size.height>0 && (begin.origin.y-end.origin.y>0) ) {
        if (_keyboardIsShown) {
            return ;
        }
        NSDictionary *userInfo = [notification userInfo];
        CGFloat h = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,0);
        WS(weakSelf);
        [Util commonViewAnimation:^{
            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
        }
                       completion:nil];
        _keyboardIsShown = YES;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,0);
    WS(weakSelf);
    [Util commonViewAnimation:^{
        weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
    }
                   completion:nil];
    _keyboardIsShown = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
