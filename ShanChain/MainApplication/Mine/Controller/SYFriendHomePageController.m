//
//  SYFriendHomePageController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/9.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYFriendHomePageController.h"
#import "SCDynamicCell.h"
#import "SCDynamicStatusFrame.h"
#import "SYCharacterModel.h"
#import "SYMessageController.h"
#import "SCReportController.h"

@interface SYFriendHomePageController ()<SYStoryListDelegate>{
}

@property (assign, nonatomic) int pageIndex;

@property (strong, nonatomic) UITableView      *tableView;

@property (strong, nonatomic) NSMutableArray   *dynamicFrames;//数组

@property (strong, nonatomic) SYCharacterModel *characterModel;
// 头部视图
@property (strong, nonatomic) UIView *headView;

@property (strong, nonatomic) UIImageView *headBackground;
@property (strong, nonatomic) UIImageView *headIconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *introLabel;
// 关注按钮
@property (strong, nonatomic) UIButton *followButton;

@property (strong, nonatomic) UIView *emptyView;

@property (assign, nonatomic) BOOL isShowTalk;

@property (assign, nonatomic) BOOL isFollow;

@end

@implementation SYFriendHomePageController

- (UIView *)emptyView {
    if(!_emptyView) {
        _emptyView = [SYUIFactory emptyViewWithTitle:@"暂时还没有动态,可以现在去添加" withColor:RGB_HEX(0x666666) withBackgroundColor:RGB_HEX(0xFFFFFF)];
        _emptyView.hidden = YES;
    }
    
    return _emptyView;
}

#pragma mark -懒加载
- (void)setIsFollow:(BOOL)isFollow {
    _isFollow = isFollow;
    self.followButton.selected = isFollow;
}

- (void)setCharacterModel:(SYCharacterModel *)characterModel {
    _characterModel = characterModel;
    
    NSString *currentUserId = [SCCacheTool.shareInstance getCurrentUser];
    NSString *currentSpaceId = [SCCacheTool.shareInstance getCurrentSpaceId];
    if (![characterModel.userId isEqualToString:currentUserId] && [characterModel.spaceId isEqualToString:currentSpaceId]) {
        self.isShowTalk = YES;
    }
    
    [self.tableView reloadData];
}

- (void)initFromRnData {
    if (self.rnParams) {
        NSDictionary *rnData = [JsonTool dictionaryFromString:self.rnParams];
        NSDictionary *data = [rnData objectForKey:@"data"];
        if ([data objectForKey:@"characterId"]) {
            self.characterId = [data objectForKey:@"characterId"];
        }
    }
}


- (void)addNavigation{
    if (self.characterModel.userId.integerValue != [SCCacheTool shareInstance].getCurrentUser.integerValue) {
        [self addNavigationRightWithImageName:@"abs_home_btn_more_default" withTarget:self withAction:@selector(moreAction:)];
    }
}

- (void)layoutUI {
    [super layoutUI];
    
    self.title = @"人物名牌";
    // 当前ID不等于用户ID时才能举报

    [self initFromRnData];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.view insertSubview:self.emptyView belowSubview:self.tableView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.left.right.bottom.mas_equalTo(0);
    }];
     
    self.delegate = self;
    self.isRow = YES;
    self.tableView.backgroundColor = [UIColor clearColor];

    [self requestCharacterDetail];
}

#pragma mark ------- request data ----------------------
- (void)requestCharacterDetail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:@{@"characterId": self.characterId}];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYCHARACTQUERYBYID parameters:params success:^(id responseObject) {
        NSMutableDictionary *contentDic = responseObject[@"data"];
        if (contentDic == [NSNull null] || !contentDic.allKeys) {
            [SYProgressHUD showError:@"角色信息获取错误"];
            return;
        }
        
        SYCharacterModel *model = [SYCharacterModel objectWithKeyValues:contentDic];
        WeakSelf.characterModel = model;
        [self addNavigation];
        [WeakSelf.tableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        SCLog(@"请求数据失败");
    }];
}

- (void)requestDataHandler {
    if (!self.characterModel) {
        [self.tableView mj_endRefreshing];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:@{
                                             @"spaceId": self.characterModel.spaceId,
                                             @"targetId": self.characterModel.characterId,
                                             @"characterId": [[SCCacheTool shareInstance] getCurrentCharacterId],
                                             @"userId": [[SCCacheTool shareInstance] getCurrentUser],
                                             @"page": [NSNumber numberWithInt:self.pageIndex],
                                             @"size": [NSNumber numberWithInt:10]
                                             }];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORY_LIST_BY_CHARACTER parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSArray *dataArr = data[@"content"];
        if (WeakSelf.pageIndex != 0 && dataArr.count == 0) {
            // 如果没有数据当前的页码得恢复
            [WeakSelf.tableView mj_endRefreshing];
            WeakSelf.pageIndex -= 1;
            return;
        }
        NSMutableArray *detailIdsArray = [NSMutableArray array];
        for (int i = 0; i < dataArr.count; i ++) {
            NSMutableDictionary *dict = dataArr[i];
            NSString *detailId = dict[@"detailId"];
            [detailIdsArray addObject:detailId];
        }
        [WeakSelf requestDetailListData:detailIdsArray];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        SCLog(@"请求数据失败");
    }];
}

- (void)requestDetailListData:(NSArray *) detailIdArray {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:@{
                                             @"userId": [SCCacheTool.shareInstance getCurrentUser],
                                             @"characterId": [SCCacheTool.shareInstance getCurrentCharacterId],
                                             @"dataArray": [JsonTool stringFromArray:detailIdArray]
                                             }];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYRECOMMENDDETAIL parameters:params success:^(id responseObject) {
        NSMutableArray *data = [responseObject[@"data"] mutableCopy];
        if (WeakSelf.pageIndex == 0) {//下拉刷新
            [WeakSelf.dynamicFrames removeAllObjects];
        }
        NSArray *models = [SCDynamicModel objectArrayWithKeyValuesArray:data];
        NSArray *statusFrames = [WeakSelf dynamicFramesWithModels:models];
        [WeakSelf.dynamicFrames addObjectsFromArray:statusFrames];
        [WeakSelf.tableView mj_endRefreshing];
        [WeakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        SCLog(@"%@",error);
    }];
}

- (NSArray *)dynamicFramesWithModels:(NSArray *)models {
    NSMutableArray *array = [NSMutableArray array];
    for(SCDynamicModel *model  in models){
        SCDynamicStatusFrame *statusFrame = [[SCDynamicStatusFrame alloc] init];
        model.showChain = NO;
        model.showToolBar = model.type != 3;
        statusFrame.dynamicModel = model;
        [array addObject:statusFrame];
    }
    return array;
}

- (int)getTableDataIndexWith:(NSIndexPath *)indexPath {
    return indexPath.row;
}

#pragma mark ------------ SYStoryListDelegate Delegate ----------------------
- (NSInteger)storyListNumberOfSectionsInTableView:(UITableView *)tableView {
    return self.characterModel ? 1 : 0;
}

- (NSInteger)storyListTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.emptyView.hidden = !self.characterModel || self.dynamicFrames.count;
    return self.dynamicFrames.count;
}

- (CGFloat)storyListTableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.isShowTalk ? 270 : 170;
}

- (UIView *)storyListTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_headView) {
        return _headView;
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.width, self.isShowTalk ? 270 : 170);
    headerView.backgroundColor = [UIColor whiteColor];
    _headBackground = [[UIImageView alloc] init];
    _headBackground.frame = CGRectMake(0, 0, self.view.width, 170);
    _headBackground.userInteractionEnabled = YES;
    [headerView addSubview:_headBackground];
    
    _headIconView = [[UIImageView alloc] init];
    [_headIconView preventImageViewExtrudeDeformation];
    [_headIconView makeLayerWithRadius:35 withBorderColor:[UIColor whiteColor] withBorderWidth:2];
    [_headBackground addSubview:_headIconView];
    [_headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headBackground);
        make.width.height.mas_equalTo(70);
        make.top.equalTo(_headBackground).with.offset(20);
    }];
    
    if (self.characterModel) {
        self.headBackground.image = [UIImage imageNamed:@"background_homePage"];
        [self.headIconView sd_setImageWithURL:[NSURL URLWithString:self.characterModel.headImg]];
    }
    
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel makeTextStyleWithTitle:self.characterModel.name withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:18] withAlignment:UITextAlignmentCenter];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_headBackground addSubview: _nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headBackground);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(250);
        make.top.equalTo(_headIconView.mas_bottom).with.offset(5);
    }];
    
    _introLabel = [[UILabel alloc] init];
    [_introLabel makeTextStyleWithTitle:self.characterModel.intro withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:12] withAlignment:UITextAlignmentCenter];
    _introLabel.backgroundColor = [UIColor clearColor];
    [_headBackground addSubview: _introLabel];
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headBackground);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(300);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
    }];
    
    if (self.isShowTalk) {
        UIView *talkView = [[UIView alloc] init];
        [headerView addSubview:talkView];
        [talkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.width.mas_equalTo(105);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(_headBackground.mas_bottom).with.offset(0);
        }];
        
        UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        followButton.frame = CGRectMake(0, 0, 100, 36);
        followButton.font = [UIFont systemFontOfSize:14];
        [followButton setTitle:@"关注TA" forState:UIControlStateNormal];
        [followButton setTitle:@"已关注" forState:UIControlStateSelected];
        followButton.selected = self.isFollow;
        [followButton makeLayerWithRadius:18 withBorderColor:[UIColor clearColor] withBorderWidth:0];
        followButton.backgroundColor = RGB_HEX(0xFFFFFF);
        [followButton setTitleColor:RGB_HEX(0xB3B3B3) forState:UIControlStateNormal];
        CALayer *shadowLayer = [[CALayer alloc] init];
        shadowLayer.frame = CGRectMake(0, 0, 100, 36);
        shadowLayer.shadowOffset = CGSizeMake(2, 2);
        shadowLayer.backgroundColor = RGB_HEX(0xB3B3B3).CGColor;
        shadowLayer.shadowOpacity = 0.7;
        shadowLayer.cornerRadius = 18;
        [talkView.layer addSublayer:shadowLayer];
        
        [talkView addSubview:followButton];
        self.followButton = followButton;
        
        UIButton *talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        talkButton.backgroundColor = [UIColor clearColor];
        talkButton.font = [UIFont systemFontOfSize:12];
        [talkButton setTitleColor:RGB_HEX(0x333333) forState:UIControlStateNormal];
        [talkButton setTitle:@"和他对话" forState:UIControlStateNormal];
        [talkButton setImage:[UIImage imageNamed:@"mine_homePage_message"] forState:UIControlStateNormal];
        [headerView addSubview:talkButton];
        [talkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(60);
            make.top.equalTo(followButton.mas_bottom).with.offset(11);
        }];
        
        CGFloat titleLabel_centerX = CGRectGetMidX(talkButton.titleLabel.frame);

        CGFloat imageView_centerX =CGRectGetMidX(talkButton.imageView.frame);

        talkButton.imageEdgeInsets = UIEdgeInsetsMake(-35, (55 - imageView_centerX), 0,0);
        talkButton.titleEdgeInsets = UIEdgeInsetsMake(0, - (55 - titleLabel_centerX), -30, 0);
        talkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [talkButton addTarget:self action:@selector(talkWithOther:) forControlEvents:UIControlEventTouchUpInside];
        [followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _headView = headerView;
    return headerView;
}

- (void)followButtonAction:(UIButton *)button {
    BOOL follow = !button.selected;
    button.selected = follow;
    [self followRequest:follow];
}

#pragma mark ------------------
- (void)talkWithOther:(UIButton *)button {
    if (!self.characterModel) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JsonTool stringFromArray:@[self.characterModel.characterId]] forKey:@"characterIds"];
    WS(WeakSelf);
    [[SCNetwork shareInstance]postWithUrl: HXUSERLIST parameters:params success:^(id responseObject) {
        NSArray *contentArray = responseObject[@"data"];
        
        if (contentArray.count > 0) {
            NSString *hxUserName = contentArray[0][@"hxUserName"];
            SYMessageController *vc = [[SYMessageController alloc] initWithConversationChatter:hxUserName conversationType:EMConversationTypeChat];
            vc.title = WeakSelf.characterModel.name;
            [WeakSelf.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        [SYProgressHUD showError:@"查询用户信息失败"];
        return;
    } failure:^(NSError *error) {
        [SYProgressHUD showError:@"查询用户信息失败"];
        SCLog(@"%@", error);
    }];

}

- (void)requestFollowState {
    if (!self.characterModel) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
    [params setObject:self.characterModel.spaceId forKey:@"spaceId"];
    [params setObject:self.characterModel.characterId forKey:@"checkId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:FRIENDISFAVORITE parameters:params success:^(id responseObject) {
        BOOL follow = [responseObject[@"data"] boolValue];
        WeakSelf.isFollow = follow;
    } failure:nil];
}

- (void)followRequest:(BOOL)follow {
    if (!self.characterModel) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (follow) {
        [params setObject:[SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"funsCharacterId"];
    } else {
        [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"funsUserId"];
    }
    [params setObject:self.characterModel.characterId forKey:@"characterId"];
    NSString *requestURL = follow ? FRIENDADDFOLLOW : FRIENDREMOVEFOLLOW;
    WS(WeakSelf);
    [[SCNetwork shareInstance]postWithUrl:requestURL parameters:params success:^(id responseObject) {
        WeakSelf.isFollow = follow;
    } failure:nil];
}


- (void)moreAction:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles = @[NSLocalizedString(@"sc_Report", comment: "字符串")];
    [self addActionTarget:alert titles:titles];
    [self addCancelActionTarget:alert title:@"取消"];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles {
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:@"举报"]) {
                SCReportController *reportVC = [[SCReportController alloc] init];
                reportVC.userId = self.characterModel.userId;
                reportVC.isReportPersonal = YES;
                [self.navigationController pushViewController:reportVC animated:YES];
            }

        }];
        [action setValue:RGB(0, 118, 255) forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}



// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [action setValue:RGB(0, 118,255) forKey:@"_titleTextColor"];
    [alertController addAction:action];
}


@end
