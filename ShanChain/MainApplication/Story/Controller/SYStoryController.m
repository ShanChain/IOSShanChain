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
        [focusVC.view setFrame:CGRectMake(0, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        
        SYStoryRecommendController *recomendVC=[[SYStoryRecommendController alloc]init];
        [recomendVC.view setFrame:CGRectMake(self.bodyScrollView.width * 2, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        
        SYStoryRealTimeController *realTimeVC=[[SYStoryRealTimeController alloc]init];
        [realTimeVC.view setFrame:CGRectMake(self.bodyScrollView.width, 0, self.bodyScrollView.width, self.bodyScrollView.height)];
        
        _userChildViewControllers = @[focusVC,realTimeVC,recomendVC];
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
        NSArray *dataArray = @[@"关注",@"实时",@"推荐"];
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
