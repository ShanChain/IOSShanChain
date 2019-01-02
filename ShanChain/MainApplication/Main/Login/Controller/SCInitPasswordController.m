//
//  SCInitPasswordController.m
//  ShanChain
//
//  Created by krew on 2017/5/18./Users/krew/Downloads/regsiter_btn_down_default@2x.png
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCInitPasswordController.h"
#import "SCLoginController.h"
#import "SCBaseNavigationController.h"

static NSString * const TYPE_BIND_MOBILE = @"BIND_MOBILE";
static NSString * const TYPE_RESET_PASSWORD = @"RESET_PASSWORD";

@interface SCInitPasswordController ()<UITextFieldDelegate>{
    BOOL _keyboardIsShown;
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UITextField   *pwdNewValueFiled;
@property (nonatomic, strong) UITextField   *phoneValueFiled;
@property (nonatomic, strong) UITextField   *verCodeValueFiled;
@property (nonatomic, strong) UIButton      *verCodeBtn;

@property (nonatomic, strong) UIButton      *sureBtn;
@property (nonatomic, assign) CGFloat       scrollViewContentHeight;
@property (nonatomic, assign) CGFloat       currOffsetY;

@property(nonatomic,strong)NSString         *verCodeString;
@property(nonatomic,strong)NSString         *type;//BIND_MOBILE,RESET_PASSWORD
@property(nonatomic,strong)NSString         *isNeedPW;//true,false


@end

@implementation SCInitPasswordController

#pragma mark -懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UITextField *)pwdNewValueFiled{
    if (!_pwdNewValueFiled) {
        _pwdNewValueFiled=[UITextField new];
        _pwdNewValueFiled.placeholder=@"请输入新密码";
        _pwdNewValueFiled.font=[UIFont systemFontOfSize:14];
        _pwdNewValueFiled.secureTextEntry=YES;
        _pwdNewValueFiled.textAlignment=NSTextAlignmentLeft;
        _pwdNewValueFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _pwdNewValueFiled.layer.masksToBounds = YES;
        _pwdNewValueFiled.layer.cornerRadius = 8.0f;
        _pwdNewValueFiled.layer.borderWidth = 1.0;
        _pwdNewValueFiled.layer.borderColor = [RGB(221, 221, 221)CGColor];
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
        leftView.backgroundColor = [UIColor clearColor];
        _pwdNewValueFiled.leftView = leftView;
        _pwdNewValueFiled.leftViewMode = UITextFieldViewModeAlways;
        [_pwdNewValueFiled setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
        [_pwdNewValueFiled setValue:RGB(221, 221, 221) forKeyPath:@"_placeholderLabel.textColor"];
        _pwdNewValueFiled.delegate = self;
    }
    return _pwdNewValueFiled;
}

-(UITextField *)phoneValueFiled{
    if (!_phoneValueFiled) {
        _phoneValueFiled=[UITextField new];
        _phoneValueFiled.placeholder=NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil);
        _phoneValueFiled.font=[UIFont systemFontOfSize:14];
        _phoneValueFiled.textAlignment=NSTextAlignmentLeft;
        _phoneValueFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _phoneValueFiled.layer.masksToBounds = YES;
        _phoneValueFiled.layer.cornerRadius = 8.0f;
        _phoneValueFiled.layer.borderWidth = 1.0;
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

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = Theme_MainThemeColor;
        ViewRadius(_sureBtn, 8);
    }
    return _sureBtn;
}

-(UITextField *)verCodeValueFiled{
    if (!_verCodeValueFiled) {
        _verCodeValueFiled=[UITextField new];
        _verCodeValueFiled.placeholder = NSLocalizedString(@"sc_login_Code", nil);
        _verCodeValueFiled.font=[UIFont systemFontOfSize:14];
        _verCodeValueFiled.textAlignment=NSTextAlignmentLeft;
        _verCodeValueFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
        [_verCodeBtn setTitle:NSLocalizedString(@"sc_login_Send", nil) forState:UIControlStateNormal];
        [_verCodeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        _verCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_verCodeBtn addTarget:self action:@selector(getVerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verCodeBtn;
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
-(void)initFromRnData{
    if (self.rnParams != nil) {
        NSDictionary *rnData = [JsonTool dictionaryFromString:self.rnParams];
        NSDictionary *data = [rnData objectForKey:@"data"];
        if ([data objectForKey:@"type"]) {
            _type = [data objectForKey:@"type"];
        }
        if ([data objectForKey:@"isNeedPW"]) {
            _isNeedPW = [data objectForKey:@"isNeedPW"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromRnData];
    _type = TYPE_RESET_PASSWORD;
   // self.type = TYPE_RESET_PASSWORD;
    self.view.backgroundColor=RGB(255, 255, 255);
    if([_type isEqualToString:TYPE_BIND_MOBILE]){
        if([_isNeedPW isEqualToString:@"false"]){
             self.title=@"更换手机";
        }else{
        self.title=@"绑定手机";
        }
        
    }else{
        self.title=@"重置密码";
    }
 
    
    [self makeSubViews];
    
    [self setKeyBoardAutoHidden];

}

#pragma mark-构造方法
-(void)makeSubViews{
    [self.view addSubview:self.scrollView];
    if(![_type isEqualToString:TYPE_BIND_MOBILE]){
         [self.scrollView addSubview:self.pwdNewValueFiled];
    }
    [self.scrollView addSubview:self.verCodeValueFiled];
    [self.scrollView addSubview:self.verCodeBtn];

    [self.scrollView addSubview:self.phoneValueFiled];
    [self.scrollView addSubview:self.sureBtn];
    
    self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat y = 0;
    if (IS_IPHONE_4_OR_LESS) {
        y = 30;
    }
    self.scrollViewContentHeight = SCREEN_HEIGHT;
    self.phoneValueFiled.frame=CGRectMake(40, 60,SCREEN_WIDTH - 40 * 2, 44);
    
    self.verCodeValueFiled.frame=CGRectMake(40, CGRectGetMaxY(self.phoneValueFiled.frame ) + KSCMargin,SCREEN_WIDTH - 40 * 2 , 44);
    
    self.pwdNewValueFiled.frame=CGRectMake(40, CGRectGetMaxY(self.verCodeValueFiled.frame) + KSCMargin, SCREEN_WIDTH - 2 * 40, 44);
    self.verCodeBtn.frame=CGRectMake(CGRectGetMaxX(self.phoneValueFiled.frame) - 100, CGRectGetMaxY(self.phoneValueFiled.frame) + KSCMargin + 12, 100, 20);
    
    self.sureBtn.frame=CGRectMake(40, CGRectGetMaxY(self.pwdNewValueFiled.frame) + 30, SCREEN_WIDTH - 40 * 2, 44);
}

-(void)getVerCodeAction{
    [self isMobilePhone:self.phoneValueFiled.text];
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
                        [self.verCodeBtn setTitle:NSLocalizedString(@"sc_login_resend", nil) forState:UIControlStateNormal];
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
        NSDictionary *data = responseObject[@"data"];
        self.verCodeString = data[@"smsVerifyCode"];
    } failure:^(NSError *error) {
        [SYProgressHUD showError:@"验证码错误"];
    }];
}

-(void)sureAction{
    if([_type isEqualToString:TYPE_RESET_PASSWORD] || ([_type isEqualToString:TYPE_BIND_MOBILE] && [_isNeedPW isEqualToString:@"true"])){
        [self.pwdNewValueFiled resignFirstResponder];
        [self.phoneValueFiled resignFirstResponder];
        if (![self.phoneValueFiled.text isNotBlank]) {
            [SYProgressHUD showError:NSLocalizedString(@"sc_login_pleaseEnterPhoneNumber", nil)];
            return;
        }
        
        if ([self.verCodeValueFiled.text isNotBlank]) {
            if (![self.verCodeValueFiled.text isEqualToString:self.verCodeString]) {
                [SYProgressHUD showError:@"验证码输入有误，请重新查看"];
                return;
            }
        } else {
            [SYProgressHUD showError:NSLocalizedString(@"sc_login_Code", nil)];
            return;
        }
        
        if (self.pwdNewValueFiled.text.length < 6 && self.pwdNewValueFiled.text.length > 16) {
            [SYProgressHUD showError:@"请输入6-12位密码"];
            return;
        }
        
        NSString *pwdMD5 = [SCMD5Tool MD5ForLower32Bate:self.pwdNewValueFiled.text];
        NSTimeInterval time =(long long) [[NSDate date] timeIntervalSince1970];
        NSString *typeAppend = [@"USER_TYPE_MOBILE" stringByAppendingString:[NSString stringWithFormat:@"%.0f",time]];
        NSString *encryptAccount = [SCAES encryptShanChainWithPaddingString:typeAppend withContent:self.phoneValueFiled.text];
        NSString *encryptPassword = [SCAES encryptShanChainWithPaddingString:[typeAppend stringByAppendingString:self.phoneValueFiled.text] withContent:pwdMD5];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"USER_TYPE_MOBILE" forKey:@"userType"];
        [params setObject:[NSString stringWithFormat:@"%0.f",time] forKey:@"Timestamp"];
        [params setObject:encryptAccount forKey:@"encryptAccount"];
        [params setObject:encryptPassword forKey:@"encryptPassword"];
        
        WS(WeakSelf);
        if([_type isEqualToString:TYPE_RESET_PASSWORD]){
            
            [[SCNetwork shareInstance]postWithUrl:COMMONUSERRESETPASSWORD parameters:params success:^(id responseObject) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SYProgressHUD showSuccess:@"修改成功"];
                    [WeakSelf.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error) {
                [SYProgressHUD showError:@"修改密码失败"];
            }];
        }else{
            NSMutableDictionary *bindParams = [NSMutableDictionary dictionary];
            [bindParams setObject:@"USER_TYPE_MOBILE" forKey:@"userType"];
            [bindParams setObject:[[SCCacheTool shareInstance] getCurrentUser] forKey:@"userId"];
            [bindParams setObject:self.phoneValueFiled.text forKey:@"otherAccount"];
            [[SCNetwork shareInstance]postWithUrl:BIND_OTHER_ACCOUNT parameters:bindParams success:^(id responseObject) {
                [SYProgressHUD showSuccess:@"绑定成功"];
                [[SCAppManager shareInstance] popViewControllerAnimated:YES];
//                [[SCNetwork shareInstance]postWithUrl:COMMONUSERRESETPASSWORD parameters:params success:^(id responseObject) {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    });
//                } failure:^(NSError *error) {
//
//                }];
            } failure:^(NSError *error) {
               // [SYProgressHUD showError:@"重置密码失败"];
                [SYProgressHUD showError:@"绑定失败"];
            }];
        }

        
    } else if ([_type isEqualToString:TYPE_BIND_MOBILE]) {
        [self.phoneValueFiled resignFirstResponder];
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
            [SYProgressHUD showError:NSLocalizedString(@"sc_login_Code", nil)];
            return;
        }
        NSMutableDictionary *bindParams = [NSMutableDictionary dictionary];
        [bindParams setObject:@"USER_TYPE_MOBILE" forKey:@"userType"];
        [bindParams setObject:[[SCCacheTool shareInstance] getCurrentUser] forKey:@"userId"];
        [bindParams setObject:self.phoneValueFiled.text forKey:@"otherAccount"];
        [[SCNetwork shareInstance]postWithUrl:BIND_OTHER_ACCOUNT parameters:bindParams success:^(id responseObject) {
            if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
                [SYProgressHUD showSuccess:@"绑定成功"];
                [[SCAppManager shareInstance] popViewControllerAnimated:YES];
            }else if ([responseObject[@"code"]isEqualToString:SC_ACCOUNT_HAS_BINDED]){
                [SYProgressHUD showSuccess:@"账号已被绑定"];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
//
//- (void)keyboardDidShow:(NSNotification*)notification {
//    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
//    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//
//    // 第三方键盘回调三次问题，监听仅执行最后一次
//    if ( begin.size.height>0 && (begin.origin.y-end.origin.y>0) ) {
//        if (_keyboardIsShown) {
//            return ;
//        }
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollViewContentHeight);
//        WS(weakSelf);
//        [Util commonViewAnimation:^{
//            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, weakSelf.currOffsetY);
//        }
//                       completion:nil];
//
//        _keyboardIsShown = YES;
//    }
//}
//
//- (void)keyboardDidHide:(NSNotification *)notification {
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollViewContentHeight+1);
//    WS(weakSelf);
//    [Util commonViewAnimation:^{
//        weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
//    } completion:nil];
//
//    _keyboardIsShown = NO;
//}


//验证手机号码
- (BOOL)isMobilePhone:(NSString *)phoneNum{
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:phoneNum]) {
        return YES;
    }
    [SYProgressHUD showError:@"抱歉！请重新输入手机号码"];
    return NO;
}

@end
