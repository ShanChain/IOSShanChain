//
//  SYStoryController.m
//  ShanChain
//
//  Created by krew on 2017/8/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryController.h"
#import "SYStoryConcernController.h"
#import "SYStoryRecommendController.h"
#import "SYStoryRealTimeController.h"
#import "SYStoryMarkController.h"
#import "SYStoryPublishController.h"
#import "SCStoryPublishDashboardView.h"
#import "SCStoryPublishVideoController.h"
#import "SYStoryTopicDetailController.h"
#import "SYFriendHomePageController.h"
#import "SYStatusTextview.h"

#define AKDKTIP  @"马甲致力于打造一个健康向上、积极的想象力社交分享平台，我们允许本网站用户发布内容，包括但不限于发布文章、图片、视频，以及通过网站评论系统发送给其他注册用户的评论，文章，链接，私人消息。马甲有权自行决定在不通知您的情况下，监控，审查，编辑，移动，删除和/或删除您随时以任何理由来往马甲用户帐户在网站上发布的任何或所有内容，或通过直接消息或任何其他方式传输的任何内容。在不限制前述规定的前提下，马甲有权自行决定删除\n您同意不：\n1 选择威胁，辱骂，冒犯，骚扰，嘲笑，诽谤，粗俗，淫秽，诽谤，仇恨，种族，民族或其他或令人反感的别名。\n2 发布或传输您知道或应该知道的任何内容是虚假的，欺骗性的或误导性的，或歪曲或欺骗他人您发布的任何评论的来源，准确性，完整性或完整性。\n3 发布或传播任何对他人非法，有害或有害的内容，包含软件病毒或其他有害的计算机代码，文件或程序，威胁，辱骂，冒犯，骚扰，嘲弄，诽谤，粗俗，淫秽，诽谤，仇恨，种族，民族或其他侵权或令人反感的。\n4 发布或传播任何侵犯或侵犯隐私或侵犯或侵犯他人权利的内容，包括但不限于版权和其他知识产权。\n5 通过使用您的别名或任何评论，冒充任何人或实体，虚假或欺骗性地陈述、推断或以其他方式谎称您与任何个人或实体的关系或联系。\n6 发布或传输任何内容，无论是发布行为还是评论本身，您无权根据任何法院，法规或任何法院的命令，或因雇用，合同，信托或其他方式而做法律义务或关系。\n7 发布或传播任何广告，宣传材料，所谓的“连锁信”，“金字塔”或其他计划或邀请参加这些或任何其他形式的招揽或促销。\n8 未经授权，发布或传输任何非公开或其他受限制的机密或专有信息。\n9 违反任何法院的任何地方，州，国家或国际法律，法规或命令，包括任何交易规则。您认为可能违反本网站使用条款的任何内容或评论。\n若用户违反以下马甲内容原则之一，马甲将保留自行决定删除的权利：\n没有煽动仇恨。将删除基于种族或民族血统，宗教，残疾，性别，年龄，退伍军人身份或性取向/性别认同而促进对群体的仇恨的材料。\n没有色情或恋童癖\n对任何人或一群人没有直接或隐蔽的威胁。\n没有版权侵权\n不发布其他人的私人和机密信息，例如信用卡号，社会保险号，驾驶员和其他许可证号码。  "


@interface SYStoryController ()<UIScrollViewDelegate, SCStoryPublishDashboardDelegate>

@property (strong, nonatomic) UIView        *mainTitleScrollView;
@property (strong, nonatomic) UIScrollView  *bodyScrollView;
@property (assign, nonatomic) NSInteger     currentIndex;
@property (strong, nonatomic) UIView        *line1View;
@property (strong, nonatomic) UIView        *line2View;
@property (strong, nonatomic) NSArray <UIViewController *>*userChildViewControllers;
@property (assign, nonatomic) BOOL          isBtnClick;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) SYStoryMarkController *markVC;
@end

@implementation SYStoryController

#pragma mark -懒加载方法
-(NSArray <UIViewController *> *)userChildViewControllers{
    if (!_userChildViewControllers) {
        SYStoryConcernController *focusVC=[[SYStoryConcernController alloc]init];
//        [focusVC.view setFrame:CGRectMake(0, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        [focusVC.view setFrame:CGRectMake(self.bodyScrollView.width, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        
        SYStoryRecommendController *recomendVC=[[SYStoryRecommendController alloc]init];
        [recomendVC.view setFrame:CGRectMake(self.bodyScrollView.width * 2, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        
        SYStoryRealTimeController *realTimeVC=[[SYStoryRealTimeController alloc]init];
      //  [realTimeVC.view setFrame:CGRectMake(self.bodyScrollView.width, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        [realTimeVC.view setFrame:CGRectMake(0, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        
        _userChildViewControllers = @[realTimeVC,focusVC,recomendVC];
    }
    return _userChildViewControllers;
}
- (SYStoryMarkController *)markVC {
    if (!_markVC) {
        _markVC = [[SYStoryMarkController alloc] init];
    }
    return _markVC;
}
#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTapTopic:) name:SYStatusTextviewNotificationTappedTopicName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTapRole:) name:SYStatusTextviewNotificationTappedRoleName object:nil];

    self.isBtnClick = NO;
    
    [self setNavigationBar];
    
    [self mainTitleScrollViewUI];
    
    [self setUI];
}

- (void)regiestNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRealtimeList:) name:NotificationNameStoryPublishSuccess object:nil];
}

#pragma mark -构造方法
-(void)setNavigationBar{
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleButton.frame = CGRectMake(100, 10.0/667*SCREEN_HEIGHT, SCREEN_WIDTH - 200, 25.0/667*SCREEN_HEIGHT);
    NSString *spaceName = [[SCCacheTool shareInstance] getCurrentSpaceName];
    spaceName = spaceName.length <= 10 ? spaceName : [[spaceName substringToIndex:9] stringByAppendingString:@"..."];
    [_titleButton setTitle:spaceName forState:UIControlStateNormal];
    [_titleButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    [_titleButton setImage:[UIImage imageNamed:@"abs_home_btn_dropdown_default"] forState:UIControlStateNormal];
    CGFloat imageViewWidth = CGRectGetWidth(_titleButton.imageView.frame);
    CGRect labelFrame = _titleButton.titleLabel.frame;
    CGFloat titleLabelWidth = CGRectGetWidth(_titleButton.titleLabel.frame);
    _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageViewWidth - 8, 0, imageViewWidth + 8);
    _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelWidth + 8, 0, -titleLabelWidth - 8);
    [_titleButton addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    
    [self addNavigationRightWithImageName:@"abs_home_btn_dynamic_default" withTarget:self withAction:@selector(publishArticle:)];
}

-(void)titleBtnClick:(UIButton *)btn {
    [self.navigationController pushViewController:self.markVC animated:false];
}

- (void)publishArticle:(UIButton *)button {
    BOOL   isRespectProtocol = [[NSUserDefaults standardUserDefaults]objectForKey:@"isRespectProtocol"];
    if (!isRespectProtocol) {
        weakify(self);
        [self hrShowAlertWithTitle:@"您需要遵守以下用户协议\n" message:AKDKTIP buttonsTitles:@[@"不同意",@"同意"] andHandler:^(UIAlertAction * _Nullable action, NSInteger indexOfAction) {
            if (indexOfAction == 1) {
                [weak_self hh_presentPublishDashboardView];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isRespectProtocol"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }];
    }else{
        [self hh_presentPublishDashboardView];
    }
 }

- (void)hh_presentPublishDashboardView{
    SCStoryPublishDashboardView *dashboardView = [[SCStoryPublishDashboardView alloc] init];
    dashboardView.delegate = self;
    [dashboardView presentView];
}


- (void)storyPublishDashboardSelectStory {
    SYStoryPublishController *vc = [[SYStoryPublishController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)storyPublishDashboardSelectPlay {
    SCStoryPublishVideoController *vc = [[SCStoryPublishVideoController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -getter方法
-(void)mainTitleScrollViewUI{
    if (!_mainTitleScrollView) {
        _mainTitleScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _mainTitleScrollView.backgroundColor = RGBA(254, 255, 255, 1.0);
        NSArray *dataArray = @[@"实时",@"关注",@"推荐"];
        CGFloat width = SCREEN_WIDTH/dataArray.count;
        for (int i = 0; i < dataArray.count; i++) {
            NSString * title = dataArray[i];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 5, width, 30)];
            button.tag=2222+i;
            [button setTitle:title forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitleColor:RGB(28, 179, 193) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
            } else {
                [button setTitleColor:RGB(83, 83, 83) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            }
            [button addTarget:self action:@selector(userZoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_mainTitleScrollView addSubview:button];
        }
        self.line1View = [[UIView alloc]initWithFrame:CGRectMake(0, _mainTitleScrollView.height-2, width, 2)];
        [self.line1View setBackgroundColor:RGB(28, 179, 193)];
        self.line2View = [[UIView alloc]initWithFrame:CGRectMake(0, _mainTitleScrollView.height-1, SCREEN_WIDTH, 1)];
        [self.line2View setBackgroundColor:RGB(179, 179, 179)];
        
        [_mainTitleScrollView addSubview:self.line2View];
        [_mainTitleScrollView addSubview:self.line1View];
        [self.view addSubview:_mainTitleScrollView];
    }
}

-(void)setUI {
    self.bodyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainTitleScrollView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    self.bodyScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.userChildViewControllers.count, 0);
    self.bodyScrollView.pagingEnabled = YES;
    self.bodyScrollView.showsHorizontalScrollIndicator = NO;
    self.bodyScrollView.bounces = NO;
    self.bodyScrollView.delegate = self;
    [self.view addSubview:self.bodyScrollView];
    [self addChildViewControllerWithIndex:0];
    [self addChildViewController:self.userChildViewControllers[0]];
    [self.bodyScrollView addSubview:self.userChildViewControllers[0].view];
    
}

- (void)updateRealtimeList:(NSNotification *)notification {
    if (self.userChildViewControllers.count > 2) {
        SYStoryRealTimeController *vc = (SYStoryRealTimeController *)self.userChildViewControllers[1];
        [vc requestData:YES];
    }
}

-(void)addChildViewControllerWithIndex:(NSInteger )index{
    UIViewController *childViewController = self.userChildViewControllers[index];
    if (![self.childViewControllers containsObject:childViewController]) {
        [self addChildViewController:childViewController];
        [childViewController didMoveToParentViewController:self];
        [self.bodyScrollView addSubview:childViewController.view];
    }
}

- (void)removeChildViewControllerWithIndex:(NSInteger)index {
    UIViewController *childViewController = self.userChildViewControllers[index];
    if ([self.childViewControllers containsObject:childViewController]) {
        [childViewController willMoveToParentViewController:nil];
        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
    }
}

-(void)userZoneBtnAction:(UIButton *)btn {
    if (btn.tag - 2222 == self.currentIndex) {
        return;
    }
    self.isBtnClick = YES;
    UIButton *lastBtn = [self.view viewWithTag:2222 + self.currentIndex];
    [lastBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [lastBtn setTitleColor:RGB(83, 83, 83) forState:UIControlStateNormal];
    
    [self removeChildViewControllerWithIndex:self.currentIndex];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btn setTitleColor:RGB(59, 186, 200) forState:UIControlStateNormal];
    
    self.currentIndex = btn.tag-2222;
    [self addChildViewControllerWithIndex:self.currentIndex];
    [self.bodyScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * self.currentIndex, 0) animated:NO];
    // 滑动line
    [self lineViewScroll];
    
    self.isBtnClick = NO;
}

-(void)lineViewScroll{
    UIButton *btn = [self.view viewWithTag:2222+self.currentIndex];
    [UIView animateWithDuration:0.25 animations:^{
        self.line1View.center = CGPointMake(btn.center.x, self.line1View.center.y);
    }];
}

#pragma mark -UIScrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isBtnClick) {
        return;
    }
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat maxOffsetX = (self.userChildViewControllers.count - 1) * SCREEN_WIDTH;
    if (offsetX <= 0 || offsetX >= maxOffsetX) {
        return;
    }
    NSInteger index = offsetX / SCREEN_WIDTH;
    CGFloat diffOffsetX = offsetX - index * SCREEN_WIDTH;
    CGFloat rate = diffOffsetX / SCREEN_WIDTH;
    CGFloat leftFontSize = 14.0f + 2 * (1 - rate);
    UIButton *leftBtn = [self.view viewWithTag:(index + 2222)];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:leftFontSize]];
    CGFloat rightFontSize = 14.0f + 2 * rate;
    UIButton *rightBtn = [self.view viewWithTag:(index + 2222 + 1)];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:rightFontSize]];
    [self addChildViewControllerWithIndex:index];
    [self addChildViewControllerWithIndex:index + 1];
    self.line1View.center = CGPointMake(offsetX / 3 + SCREEN_WIDTH / 6, self.line1View.center.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = (int)(scrollView.contentOffset.x / SCREEN_WIDTH);
    if (self.currentIndex != index) {
        UIButton *lastBtn = [self.view viewWithTag:(2222 + self.currentIndex)];
        [lastBtn setTitleColor:RGB(83, 83, 83) forState:UIControlStateNormal];
        UIButton *currentBtn = [self.view viewWithTag:(2222 + index)];
        [currentBtn setTitleColor:RGB(59, 186, 200) forState:UIControlStateNormal];
        [self removeChildViewControllerWithIndex:self.currentIndex];
        self.currentIndex = index;
    }
}

- (void)cellTapTopic:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo || !userInfo[@"beanId"]) {
        return;
    }
    SYStoryTopicDetailController *topicVC = [[SYStoryTopicDetailController alloc]init];
    topicVC.topicId = userInfo[@"beanId"];
    [self.navigationController pushViewController:topicVC animated:YES];
}

- (void)cellTapRole:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo || !userInfo[@"beanId"]) {
        return;
    }
    
    NSString *gData = [[SCCacheTool shareInstance] getGdata];
    NSDictionary *rnParams =  @{@"gData":[JsonTool dictionaryFromString:gData], @"modelId":userInfo[@"beanId"]};
    [[SCAppManager shareInstance] pushRNViewController:RN_PAGE_MODEL animated:YES parameter:[JsonTool stringFromDictionary:rnParams]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
