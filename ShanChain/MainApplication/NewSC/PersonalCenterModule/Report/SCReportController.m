//
//  SCReportController.m
//  ShanChain
//
//  Created by krew on 2017/5/31.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCReportController.h"
#import "SYReportSuccessController.h"

@interface SCReportController ()<UITextViewDelegate,UIScrollViewDelegate>{
    BOOL _keyboardIsShown;
}

@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UITextView       *textView;
@property (nonatomic, strong) UIView           *reportView;
@property (nonatomic, assign) CGFloat       currOffsetY;
@property (nonatomic, assign) NSInteger     currentIndex;

@property (nonatomic, assign) CGFloat       scrollViewContentHeight;
@property (nonatomic, strong) UILabel          *placeholderLabel;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation SCReportController
#pragma mark -懒加载

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[NSLocalizedString(@"sc_SexualViolence", nil),NSLocalizedString(@"sc_Illegal", nil),NSLocalizedString(@"sc_CopyrightInfringement", nil),NSLocalizedString(@"sc_PersonalAttacks", nil),NSLocalizedString(@"sc_Spam", nil),NSLocalizedString(@"sc_Other", nil)];
    }
    return _titles;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    }
    return _scrollView;
}

-(UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.text = @"请详细填写,以确保举报能够被受理";
        _placeholderLabel.frame = CGRectMake(KSCMargin, 8, self.textView.frame.size.width - 30, 20);
        _placeholderLabel.textColor = RGB(164, 164, 164);
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _placeholderLabel;
}


-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.reportView.frame)+20, SCREEN_WIDTH-30, 70)];
        _textView.textColor = RGB(102, 102, 102);
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.layer.borderColor = [RGB(246, 246, 246)CGColor];
        _textView.layer.borderWidth = 1.0;
        _textView.layer.cornerRadius = 8.0f;
        _textView.delegate = self;
        [_textView.layer setMasksToBounds:YES];
        
        [_textView addSubview:self.placeholderLabel];
        
    }
    return _textView;
}

-(UIView *)reportView{
    if (!_reportView) {
        _reportView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 126)];
        [self creatButton];
    }
    return _reportView;
}

//-(UIButton *)reportBtn{
//    if (!_reportBtn) {
//        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _reportBtn.frame = CGRectMake(15, CGRectGetMaxY(self.textView.frame)+20, SCREEN_WIDTH-30, 40);
//        [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
//        [_reportBtn setTitleColor:RGB(203, 203, 203) forState:UIControlStateNormal];
//        _reportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_reportBtn addTarget:self action:@selector(reportBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_reportBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_login_default"] forState:UIControlStateNormal];
//    }
//    return _reportBtn;
//}

#pragma mark -系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:self.view.window];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"sc_Report", nil);
    
    self.scrollViewContentHeight = SCREEN_HEIGHT;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentIndex = -1;
    
    [self setKeyBoardAutoHidden];
    
    [self setupUI];
}

#pragma mark -构造方法
-(void)setupUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.reportView];
    
    [self.scrollView addSubview:self.textView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sc_Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sc_cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    [self.navigationItem.rightBarButtonItem setTintColor:Theme_MainTextColor];
    [self.navigationItem.leftBarButtonItem setTintColor:Theme_MainTextColor];
}

-(void)send{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.currentIndex < 0 || (self.currentIndex == 5 && ![self.textView.text isNotBlank])) {
        [HHTool showError:@"请选择一个或输入其他内容，便于举报"];
        return;
    }
    [params setObject:(self.currentIndex == 5 ? self.textView.text : self.titles[self.currentIndex]) forKey:@"reason"];
    
    [params setObject:[SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"characterId"];
    
    NSMutableString *targetId = nil;
    if (self.isReportPersonal) {
        targetId = [[NSMutableString alloc]initWithString:self.userId];
        [params setObject:@"USER" forKey:@"reportType"];
        [params setObject:[SCCacheTool shareInstance].getCurrentCharacterId forKey:@"characterId"];
    }else{
        if (![self.detailId isNotBlank]) {
            [HHTool showError:@"动态信息有误"];
            return;
        }
        targetId  = [NSMutableString stringWithString:[self.detailId copy]];
        NSString *startCharacter = [targetId substringWithRange:NSMakeRange(0, 1)];
        [params setObject:([startCharacter isEqualToString:@"s"] ? @"STORY" : @"TOPIC") forKey:@"reportType"];
        [targetId deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    [params setObject:targetId forKey:@"targetId"];
    [HHTool showChrysanthemum];
    [[SCNetwork shareInstance] postWithUrl:self.isReportPersonal ? REPORT_USER_URL:STORYREPORT parameters:params success:^(id responseObject) {
//        SYReportSuccessController *successVC = [[SYReportSuccessController alloc]init];
//        [HHTool dismiss];
//        [self.navigationController pushViewController:successVC animated:YES];
        [HHTool showSucess:@"举报成功"];
        [self backViewController];
    } failure:^(NSError *error) {
        [HHTool dismiss];
        SCLog(@"%@",error);
    }];
    
}

-(void)creatButton {
   
    for (int i = 0; i < self.titles.count; i++) {
        UIView *containerView = [[UIView alloc] init];
        CGRect viewFrame = CGRectZero;
        viewFrame.origin.x = i % 2 ? SCREEN_WIDTH/2 : 0;
        viewFrame.origin.y = (CGFloat)((int)i / 2) * 44;
        viewFrame.size = CGSizeMake(SCREEN_WIDTH/2, 44);
        
        containerView.frame = viewFrame;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        tap.numberOfTapsRequired = 1;
        [containerView addGestureRecognizer:tap];
        containerView.tag = 2000 + i;
        [self.reportView addSubview:containerView];
        
        UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
        icon.frame = CGRectMake(20, 11, 22, 22);
        [icon setImage:[UIImage imageNamed:@"icon_btn_determine_default"] forState:UIControlStateNormal];
        [icon setImage:[UIImage imageNamed:@"icon_btn_determine_selectsd"] forState:UIControlStateSelected];
        icon.userInteractionEnabled = NO;
        [containerView addSubview:icon];

        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 0, SCREEN_WIDTH/2 - 80, 44)];
        [contentLabel makeTextStyleWithTitle:self.titles[i] withColor:RGB(83, 83, 83) withFont:[UIFont systemFontOfSize:14] withAlignment:NSTextAlignmentLeft];
        [containerView addSubview:contentLabel];
    }
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap {
    NSInteger *index = tap.view.tag - 2000;
    if (index == self.currentIndex) {
        return;
    }
    
    UIView *tapView = [self.view viewWithTag:tap.view.tag];
    UIView *oldTapView = [self.view viewWithTag:2000 + self.currentIndex];

    for (UIView *v in tapView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            btn.selected = YES;
        }
    }
    
    for (UIView *v in oldTapView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            btn.selected = NO;
        }
    }
    
    self.currentIndex = tapView.tag - 2000;
}

#pragma mark -UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    //    textview 改变字体的行间距
    if ([self.textView.text length] == 0) {
        [self.placeholderLabel setHidden:NO];
    } else {
        [self.placeholderLabel setHidden:YES];
        [self.navigationItem.rightBarButtonItem setTintColor:RGB(102, 102, 102)];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    self.placeholderLabel.hidden = self.textView.text.length;
}

- (void)cancelAction{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
