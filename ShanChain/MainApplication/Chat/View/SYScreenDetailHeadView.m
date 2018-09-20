//
//  SYScreenDetailHeadView.m
//  ShanChain
//
//  Created by krew on 2017/9/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScreenDetailHeadView.h"
#import "SYCommonRoleView.h"

#pragma mark - Class define variable
#define K_MAIN_VIEW_SCROLL_HEIGHT 36.0f
#define K_MAIN_VIEW_SCROLL_TEXT_TAG 300
#define K_MAIN_VIEW_TEME_INTERVAL 0.35                //计时器间隔时间(单位秒)
#define K_MAIN_VIEW_SCROLLER_SPACE 20.0f              //每次移动的距离
#define K_MAIN_VIEW_SCROLLER_LABLE_WIDTH     18.0f    //单个字符宽度(与你设置的字体大小一致)
#define K_MAIN_VIEW_SCROLLER_LABLE_MARGIN    20.0f    //前后间隔距离
#define K_MAIN_VIEW_SCROLLER_SLEEP_INTERVAL  1        //停留时间


@interface SYScreenDetailHeadView()<SYCommonRoleViewDelegate>

@property(nonatomic,strong)NSMutableArray *arrData;

@property(nonatomic,strong)UIScrollView *scrollViewText;
@property(nonatomic,strong)NSTimer      *timer;

@property(nonatomic,strong)UIView       *headView;
@property(nonatomic,strong)UIImageView  *imgView;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UILabel      *contentLabel;
@property(nonatomic,strong)UIButton     *qrCode;
@property(nonatomic,strong)UIView       *lineView;

@property (strong, nonatomic) SYCommonRoleView *roleCollectionView;

@end

@implementation SYScreenDetailHeadView
#pragma mark -懒加载
- (UIView *)headView{
    if(!_headView){
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        _headView.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_headView addGestureRecognizer:bgViewTap];
    }
    return _headView;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCMargin, KSCMargin, 55, 55)];
        _imgView.image = [UIImage imageNamed:@"run4.jpg"];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 8.0f;
    }
    
    return _imgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame) + KSCMargin, KSCMargin, 200, 20)];
        _nameLabel.text = @"亚洲一号";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = RGB(102, 102, 102);
    }
    return _nameLabel;
}

- (UIButton *)qrCode{
    if (!_qrCode) {
        _qrCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _qrCode.frame = CGRectMake(SCREEN_WIDTH - KSCMargin - 6, 48, 6, 12);
        [_qrCode setImage:[UIImage imageNamed:@"abs_meet_btn_enter_default"] forState:UIControlStateNormal];
        [_qrCode addTarget:self action:@selector(qrCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCode;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel makeTextStyleWithTitle:@"" withColor:RGB(102, 102, 102) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - KSCMargin * 3- CGRectGetMaxX(self.imgView.frame)  , MAXFLOAT);
        CGSize textSize = [_contentLabel.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _contentLabel.frame = (CGRect){{CGRectGetMaxX(self.imgView.frame) + KSCMargin , CGRectGetMaxY(self.nameLabel.frame) + 10} , textSize };
    }
    return _contentLabel;
}

- (void)setTitle:(NSString *)title withDetail:(NSString *)detail {
    self.nameLabel.text     = title;
    self.contentLabel.text  = detail;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 119, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = RGB(238, 238, 238);
    }
    return _lineView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self setupView];
    }
    return self;
}

- (void)initView{
    if (!_arrData) {
        _arrData = @[
                        @{
                             @"newsId"   :@"201507070942261935",
                             @"newsImg"  :@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/sy_2015070709395519.jpg",
                             @"newsTitle":@"公告：三大理由欧元任性抗跌，欧元区峰会将为希腊定调"
                             },
                         @{
                             @"newsId"   :@"201507070942261938",
                             @"newsImg"  :@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/sy_2015070709395519.jpg",
                             @"newsTitle":@"公告：三大理由欧元任性抗跌，欧元区峰会将为希腊定调"
                             },
                         ];
                        
    }
    //文字滚动
//    [self initScrollText];
    
    //开启滚动
//    [self startScroll];
}

- (void)setupView {
    [self addSubview:self.headView];
    [self.headView addSubview:self.scrollViewText];
    [self.headView addSubview:self.imgView];
    [self.headView addSubview:self.nameLabel];
    [self.headView addSubview:self.qrCode];
    [self.headView addSubview:self.contentLabel];
    [self.headView addSubview:self.lineView];
    
    SYCommonRoleView *v = [[SYCommonRoleView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 150)];
    v.delegate = self;
    [self addSubview:v];
    self.roleCollectionView = v;
}

//文字滚动初始化
-(void) initScrollText{
    
    //获取滚动条
    _scrollViewText = (UIScrollView *)[self viewWithTag:K_MAIN_VIEW_SCROLL_TEXT_TAG];
    if(!_scrollViewText){
        _scrollViewText = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, K_MAIN_VIEW_SCROLL_HEIGHT)];
        _scrollViewText.showsHorizontalScrollIndicator = NO;   //隐藏水平滚动条
        _scrollViewText.showsVerticalScrollIndicator = NO;     //隐藏垂直滚动条
        _scrollViewText.scrollEnabled = NO;                    //禁用手动滑动
        
        //横竖屏自适应
        _scrollViewText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollViewText.tag = K_MAIN_VIEW_SCROLL_TEXT_TAG;
        [_scrollViewText setBackgroundColor:RGB(255, 237, 219)];
        
        //给滚动视图添加事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerViewClick:)];
        [_scrollViewText addGestureRecognizer:tapGesture];
        
        //添加到当前视图
    }else{
        //清除子控件
        for (UIView *view in [_scrollViewText subviews]) {
            [view removeFromSuperview];
        }
    }
    
    if (self.arrData) {
        
        CGFloat offsetX = 0 ,i = 0, h = 30;
        //设置滚动文字
        UIButton *btnText = nil;
        NSString *strTitle = [[NSString alloc] init];
        
        for (NSDictionary *dicTemp in self.arrData) {
            
            strTitle = dicTemp[@"newsTitle"];
            
            btnText = [UIButton buttonWithType:UIButtonTypeCustom];
            btnText.titleLabel.font = [UIFont systemFontOfSize:12];
            [btnText setFrame:CGRectMake([self getTitleLeft:i],
                                         (K_MAIN_VIEW_SCROLL_HEIGHT - h) / 2,
                                         strTitle.length * K_MAIN_VIEW_SCROLLER_LABLE_WIDTH,
                                         h)];
            
            [btnText setTitleColor:RGB(255, 130, 0) forState:UIControlStateNormal];
            [btnText setTitle:strTitle forState:UIControlStateNormal];
            
            //横竖屏自适应
            btnText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            offsetX += btnText.frame.origin.x;
            
            //设置为 NO,否则无法响应点击事件
            btnText.userInteractionEnabled = NO;
            
            //添加到滚动视图
            [_scrollViewText addSubview:btnText];
            
            i++;
        }
        
        //设置滚动区域大小
        [_scrollViewText setContentSize:CGSizeMake(offsetX, 0)];
    }
}

#pragma mark - 滚动处理
//开始滚动
-(void) startScroll{
    
    if (!_timer)
        _timer = [NSTimer scheduledTimerWithTimeInterval:K_MAIN_VIEW_TEME_INTERVAL target:self selector:@selector(setScrollText) userInfo:nil repeats:YES];
    
    [_timer fire];
    
}


//滚动处理
-(void) setScrollText{
    [UIView animateWithDuration:K_MAIN_VIEW_TEME_INTERVAL * 2 animations:^{
        CGRect rect;
        CGFloat offsetX = 0.0, width = 0.0;
        
        for (UIButton *btnText in _scrollViewText.subviews) {
            
            rect = btnText.frame;
            offsetX = rect.origin.x - K_MAIN_VIEW_SCROLLER_SPACE;
            width = [btnText.titleLabel.text length] * K_MAIN_VIEW_SCROLLER_LABLE_WIDTH;
            
            btnText.frame = CGRectMake(offsetX, rect.origin.y, rect.size.width, rect.size.height);
        }
        
        if (offsetX < -width){
            [UIView setAnimationsEnabled:NO];
            [self initScrollText];
        }else
            [UIView setAnimationsEnabled:YES];
    }];
    
}

-(void)btnNewsClick:(UIButton *) sender{
    if (_delegate && [_delegate respondsToSelector:@selector(screenDetailHeadViewNoticeBtnAction)]) {
        [_delegate screenDetailHeadViewNoticeBtnAction];
    }
}

-(void)scrollerViewClick:(UITapGestureRecognizer*)gesture{
    
    CGPoint touchPoint = [gesture locationInView:_scrollViewText];
    
    for (UIButton *btn in _scrollViewText.subviews) {
        
        if ([btn.layer.presentationLayer hitTest:touchPoint]) {
            [self btnNewsClick:btn];
            break;
        }
        
    }
    
}

-(float) getTitleLeft:(CGFloat) i {
    float left = i * K_MAIN_VIEW_SCROLLER_LABLE_MARGIN;
    
    if (i > 0) {
        for (int j = 0; j < i; j ++) {
            left += [[self.arrData objectAtIndex:j][@"newsTitle"] length] * K_MAIN_VIEW_SCROLLER_LABLE_WIDTH;
        }
    }
    
    return left;
}

- (void)updateMemberList:(NSArray *)array {
    [self.roleCollectionView updateDataArray:array];
}

- (void)tapClick{
    if (_delegate && [_delegate respondsToSelector:@selector(createScreenViewAction)]) {
        [_delegate createScreenViewAction];
    }
}

@end
