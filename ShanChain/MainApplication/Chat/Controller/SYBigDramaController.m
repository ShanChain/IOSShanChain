//
//  SYBigDramaController.m
//  ShanChain
//
//  Created by krew on 2017/9/13.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYBigDramaController.h"
#import "THDatePickerView.h"


@interface SYBigDramaController ()<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,THDatePickerViewDelegate>{
    BOOL _keyboardIsShown;
}

@property (weak, nonatomic) THDatePickerView *dateView;

@property(nonatomic,strong)UIScrollView     *scrollView;
@property(nonatomic,strong)UILabel          *nameLabel;
@property(nonatomic,strong)UITextField      *inputField;
@property(nonatomic,strong)UIView           *lineView;

@property(nonatomic,strong)UILabel          *nameLabel1;
@property(nonatomic,strong)UITextView       *textView;
@property(nonatomic,strong)UILabel          *placeholderLabel;

@property(nonatomic,strong)UIView           *startView;
@property(nonatomic,strong)UILabel          *nameLabel2;
@property(nonatomic,strong)UILabel          *contentLabel;
@property(nonatomic,strong)UIImageView      *arrowImgView;

@property(nonatomic,strong)UIButton         *startBtn;
@property(nonatomic,strong)UIButton         *quitBtn;

@property(nonatomic,strong)UILabel          *despritionLabel;

@property (nonatomic, assign) CGFloat       scrollViewContentHeight;
@property (nonatomic, assign) CGFloat       currOffsetY;

@property(nonatomic,strong)UIView *registerBgView;


@end

@implementation SYBigDramaController
#pragma mark -懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"戏名";
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.frame = CGRectMake(KSCMargin, 20, 40, 20);
    }
    return _nameLabel;
}

- (UITextField *)inputField{
    if (!_inputField) {
        _inputField = [UITextField new];
        _inputField.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + KSCMargin, 20, 250, 20);
        _inputField.font = [UIFont systemFontOfSize:14];
        _inputField.delegate = self;
    }
    return _inputField;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.frame = CGRectMake(0, 60.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 1);
        _lineView.backgroundColor = RGB(238, 238, 238);
    }
    return _lineView;
}

- (UILabel *)nameLabel1{
    if (!_nameLabel1) {
        _nameLabel1 = [UILabel new];
        _nameLabel1.frame = CGRectMake(15, 80.0/667*SCREEN_HEIGHT, 40, 20);
        _nameLabel1.text = @"梗概";
        _nameLabel1.textColor = RGB(102, 102, 102);
        _nameLabel1.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel1;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel ) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textColor  = RGB(179, 179, 179);
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.text = @"围绕以下梗概进行正式、公正的对戏";
        _placeholderLabel.frame = CGRectMake(5, 4, 250, 20);
    }
    return _placeholderLabel;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(60.0/375*SCREEN_WIDTH, 75.0/667*SCREEN_HEIGHT, 300.0/375*SCREEN_WIDTH, 130)];
        _textView.delegate = self;
        [_textView addSubview:self.placeholderLabel];
        
    }
    return _textView;
}

- (UIView *)startView{
    if (!_startView) {
        _startView = [[UIView alloc]initWithFrame:CGRectMake(0, 200.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 60)];
        _startView.layer.borderColor = [RGB(238, 238, 238)CGColor];
        _startView.layer.borderWidth = 1.0f;
        _startView.userInteractionEnabled = YES;
//        _startView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        tapAction.delegate = self;
        [_startView addGestureRecognizer:tapAction];
    }
    return _startView;
}

- (UILabel *)nameLabel2{
    if (!_nameLabel2) {
        _nameLabel2 = [UILabel new];
        _nameLabel2.frame = CGRectMake(KSCMargin, 20, 80, 20);
        _nameLabel2.text = @"开戏倒计时";
        _nameLabel2.font = [UIFont systemFontOfSize:14];
        _nameLabel2.textColor = RGB(102, 102, 102);
    }
    return _nameLabel2;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]init];
        _arrowImgView.image = [UIImage imageNamed:@"abs_meet_btn_enter_default"];
        _arrowImgView.frame = CGRectMake(SCREEN_WIDTH - KSCMargin - 6, 23, 6, 12);
        _arrowImgView.userInteractionEnabled = YES;
    }
    return _arrowImgView;
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.frame = CGRectMake(CGRectGetMinX(self.arrowImgView.frame) - 150, 20, 140, 20);
        _contentLabel.textColor = RGB(179, 179, 179);
        _contentLabel.text = @"请选择";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(KSCMargin, 335.0/667*SCREEN_HEIGHT, SCREEN_WIDTH - 2 * KSCMargin, 40);
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"abs_drama_btn_determine_default"] forState:UIControlStateNormal];
        [_startBtn setTitle:@"准备开场" forState:UIControlStateNormal];
        [_startBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)quitBtn{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _quitBtn.frame = CGRectMake(KSCMargin, 395.0/667*SCREEN_HEIGHT, SCREEN_WIDTH - 2 * KSCMargin, 40);
        [_quitBtn setBackgroundImage:[UIImage imageNamed:@"abs_drama_btn_cancel_default"] forState:UIControlStateNormal];
        [_quitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_quitBtn setTitleColor:RGB(59, 186, 200) forState:UIControlStateNormal];
        _quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_quitBtn addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (UILabel *)despritionLabel{
    if (!_despritionLabel ) {
        _despritionLabel = [UILabel new];
        _despritionLabel.text = @"你可以根据成员的签到情况更新这些设置，提前，推迟或者取消";
        _despritionLabel.textColor = RGB(179, 179, 179);
        _despritionLabel.font = [UIFont systemFontOfSize:12];
        _despritionLabel.frame = CGRectMake(KSCMargin, 445.0/667*SCREEN_HEIGHT, SCREEN_WIDTH - 2 * KSCMargin, 17);
    }
    return _despritionLabel;
}

#pragma mark -系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.registerBgView.hidden=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"大戏";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollViewContentHeight = SCREEN_HEIGHT;
    
    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260)];
    dateView.delegate = self;
    
    self.dateView = dateView;
    
    [self setupViews];
    
    [self setKeyBoardAutoHidden];

}

#pragma mark - 构造方法
- (void)setupViews{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.inputField];
    [self.scrollView addSubview:self.lineView];
    [self.scrollView addSubview:self.nameLabel1];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.startView];
    [self.startView addSubview:self.nameLabel2];
    [self.startView addSubview:self.arrowImgView];
    [self.startView addSubview:self.contentLabel];
    
    [self.scrollView addSubview:self.startBtn];
    [self.scrollView addSubview:self.quitBtn];

    [self.scrollView addSubview:self.despritionLabel];
    [self.scrollView addSubview:self.dateView];
}

- (void)tapAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        UIView *registerBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        registerBgView.backgroundColor=RGBA(0, 0, 0, 0.4);
        self.registerBgView=registerBgView;
#warning 取出最上面的View
        [[[[UIApplication sharedApplication]windows]lastObject]addSubview:registerBgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        registerBgView.userInteractionEnabled = YES;
        [registerBgView addGestureRecognizer:tap];
        
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        self.dateView.backgroundColor = [UIColor whiteColor];
        [self.dateView show];
    }];
}

-(void)closeTap{
    [UIView animateWithDuration:0.25 animations:^{
        self.registerBgView.hidden=YES;
    }];
}

- (void)startAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self.inputField.text isNotBlank]) {
        [params setObject:self.inputField.text forKey:@"title"];
    }else{
        [SYProgressHUD showError:@"请输入戏名"];
        return;
    }
    
    if ([self.textView.text isNotBlank]) {
        [params setObject:self.textView.text forKey:@"intro"];
    }else{
        [SYProgressHUD showError:@"请输入梗概"];
        return;
    }
    NSTimeInterval time =(long long) [[NSDate date] timeIntervalSince1970];
    [params setObject:@(time) forKey:@"startTime"];
    [params setObject:@"27847047577601" forKey:@"groupId"];
    
    [[SCNetwork shareInstance]postWithUrl:HXGAMECREATE parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
            
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
}

- (void)quitAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    if ([self.textView.text length] == 0) {
        [self.placeholderLabel setHidden:NO];
    }else{
        [self.placeholderLabel setHidden:YES];
    }
}

#pragma mark -通知
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
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollViewContentHeight);
        WS(weakSelf);
        [Util commonViewAnimation:^{
            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, weakSelf.currOffsetY);
        }
                       completion:nil];
        _keyboardIsShown = YES;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollViewContentHeight+1);
    WS(weakSelf);
    [Util commonViewAnimation:^{
        weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
    }
                   completion:nil];
    
    _keyboardIsShown = NO;
}

#pragma mark -ApprDataPickeryMdDelegate
- (void)selectDateMd:(NSString *)date indexPath:(NSIndexPath *)indexPath{
    self.contentLabel.text = date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    self.contentLabel.text = timer;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
        self.registerBgView.hidden=YES;

        
    }];
}

@end
