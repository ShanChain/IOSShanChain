//
//  SYStoryListBaseController.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/4.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYStoryListBaseController.h"
#import "SCDynamicCell.h"
#import "SCDynamicStatusFrame.h"
#import "SYStoryContentController.h"
#import "SYStoryTopicDetailController.h"
#import "SYStoryRetweetController.h"
#import "SYFriendHomePageController.h"
#import "SYStoryTransmitController.h"
#import "SYStatusTextview.h"
#import "SCReportController.h"
#import "SCCommonShareDashboardView.h"

#define REPORT @"举报"
#define DELETE @"删除"

@interface SYStoryListBaseController()<UITableViewDelegate, UITableViewDataSource, SCDynamicCellDelegate, UIActionSheetDelegate>{
}

//动态楼层记录
@property (strong, nonatomic) NSMutableArray *chainData;

@end

@implementation SYStoryListBaseController

#pragma mark -懒加载
-(NSMutableArray *)dynamicFrames{
    if (!_dynamicFrames) {
        _dynamicFrames = [NSMutableArray array];
    }
    return _dynamicFrames;
}

- (NSMutableArray *)chainData {
    if (!_chainData) {
        _chainData = [NSMutableDictionary dictionary];
    }
    return _chainData;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40 - 49);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = RGB(238, 238, 238);
        [_tableView registerClass:[SCDynamicCell class] forCellReuseIdentifier:[SCDynamicCell cellDequeueReusableIdentifier]];
        [self initRefreshView];
    }
    return _tableView;
}

#pragma mark -------- init data ------------
- (void)initRefreshView {
    WS(WeakSelf);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        WeakSelf.pageIndex = 0;
        [self requestDataHandler];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WeakSelf.pageIndex += 1;
        [self requestDataHandler];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
}

- (void)layoutUI {
    [self.view addSubview:self.tableView];
    
    [self requestData:YES];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionMore:) name:SYStoryDidReportNotication object:nil];;
}

#pragma mark ------ lifeCycle -----------

- (void)requestData:(BOOL)isReload {
    if (isReload) {
        [self.tableView.mj_header beginRefreshing];
        self.tableView.contentOffset = CGPointZero;
    } else {
        // 刷新可见cell就行 优化
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    /** 结束刷新状态*/
    [self.tableView mj_endRefreshing];
}

#pragma mark ------- request data ----------------------
// for override
- (void)requestDataHandler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:@{
                                             @"userId": [SCCacheTool.shareInstance getCurrentUser],
                                             @"spaceId": [SCCacheTool.shareInstance getCurrentSpaceId],
                                             @"characterId": [SCCacheTool.shareInstance getCurrentCharacterId],
                                             @"page":@(self.pageIndex),
                                             @"size":@(10)
                                             }];
    WS(WeakSelf);
    [SCNetwork.shareInstance postWithUrl:self.requestURL parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSArray *dataArr = data[@"content"];
        if (WeakSelf.pageIndex != 0 && dataArr.count == 0) {
            // 如果没有数据当前的页码得恢复
            [WeakSelf.tableView mj_endRefreshing];
            WeakSelf.pageIndex -= 1;
            return;
        }
        WeakSelf.chainData = dataArr;
        NSMutableArray *detailIdsArray = [NSMutableArray array];
        for (int i = 0; i < dataArr.count; i ++) {
            NSMutableDictionary *dict = dataArr[i];
            if (!dict) {
                continue;
            }
            NSString *detailId = dict[@"detailId"];
            [detailIdsArray addObject:detailId];
            
            NSMutableDictionary *chain = dict[@"chain"];
            NSArray *chainIds = chain[@"detailIds"];
            [detailIdsArray addObjectsFromArray:chainIds];
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
    [SCNetwork.shareInstance postWithUrl:STORYRECOMMENDDETAIL parameters:params success:^(id responseObject) {
        NSMutableArray *data = [responseObject[@"data"] mutableCopy];
        if (WeakSelf.pageIndex == 0) {//下拉刷新
            [WeakSelf.dynamicFrames removeAllObjects];
        }
        
        NSArray *models = [SCDynamicModel objectArrayWithKeyValuesArray:data];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (SCDynamicModel *model in models) {
            [dict setObject:model forKey:model.detailId];
        }
        NSMutableArray *modelArray = [NSMutableArray array];
        for (int i = 0; i < WeakSelf.chainData.count; i ++) {
            NSMutableDictionary *element = WeakSelf.chainData[i];
            NSString *detailId = element[@"detailId"];
            SCDynamicModel *model = dict[detailId];
            if (model) {
                NSMutableDictionary *chain = element[@"chain"];
                NSArray *chainIds = chain[@"detailIds"];
                for (NSString *d in chainIds) {
                    SCDynamicModel *chainModel = dict[d];
                    if (chainModel) {
                        [model.chains addObject:chainModel];
                    }
                }
                [modelArray addObject:model];
            }
        }
        NSArray *statusFrames = [WeakSelf dynamicFramesWithModels:modelArray];
        [WeakSelf.dynamicFrames addObjectsFromArray:statusFrames];

        [WeakSelf.tableView mj_endRefreshing];
        [WeakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        SCLog(@"%@",error);
    }];
}

- (NSArray *)dynamicFramesWithModels:(NSArray *)models {
    NSMutableArray *array=[NSMutableArray array];
    for(SCDynamicModel *model in models){
        SCDynamicStatusFrame *statusFrame = [[SCDynamicStatusFrame alloc]init];
        model.showToolBar = model.type != 3;
        statusFrame.dynamicModel = model;
        [array addObject:statusFrame];
    }
    return array;
}

- (int)getTableDataIndexWith:(NSIndexPath *)indexPath {
    return indexPath.section;
}

#pragma mark ------------ UITableView Delegate ----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    SCLog(@"numberOfSectionsInTableView:");
    if ([self.delegate respondsToSelector:@selector(storyListNumberOfSectionsInTableView:)]) {
        return [self.delegate storyListNumberOfSectionsInTableView:tableView];
    } else {
        return self.dynamicFrames.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    SCLog(@"tableView:numberOfRowsInSection:%d", section);
    if ([self.delegate respondsToSelector:@selector(storyListTableView:numberOfRowsInSection:)]) {
        return [self.delegate storyListTableView:tableView numberOfRowsInSection:section];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SCLog(@"tableView:cellForRowAtIndexPath:%@", indexPath);
    if ([self.delegate respondsToSelector:@selector(storyListTableView:cellForRowAtIndexPath:)]) {
        return [self.delegate storyListTableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        SCDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:[SCDynamicCell cellDequeueReusableIdentifier] forIndexPath:indexPath];
        NSInteger i = self.isRow ? indexPath.row:indexPath.section;
        SCDynamicStatusFrame *statusFrame = self.dynamicFrames[i];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.dynamicStatusFrame = statusFrame;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    SCLog(@"tableView:heightForHeaderInSection:%d", section);
    if ([self.delegate respondsToSelector:@selector(storyListTableView:heightForHeaderInSection:)]) {
        return [self.delegate storyListTableView:tableView heightForHeaderInSection:section];
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    SCLog(@"tableView:viewForHeaderInSection:%d", section);
    if ([self.delegate respondsToSelector:@selector(storyListTableView:viewForHeaderInSection:)]) {
        return [self.delegate storyListTableView:tableView viewForHeaderInSection:section];
    } else {
        return nil;
    }
}

#pragma mark -UITableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SCLog(@"tableView:heightForRowAtIndexPath:%@", indexPath);
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    return statusFrame.dynamicCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    SCLog(@"tableView:heightForFooterInSection:%d", section);
    return section == self.dynamicFrames.count - 1 ? 0 : 5;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SCLog(@"tableView:estimatedHeightForRowAtIndexPath:%@", indexPath);
//    return 100;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    SCLog(@"tableView:viewForFooterInSection:%d", section);
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5)];
    footerView.opaque = NO;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    [self _enterStoryDetailWithModel:statusFrame.dynamicModel];
}

- (void)_enterStoryDetailWithModel:(SCDynamicModel *)model {
    if (model.type == 1 || model.type == 2) {
        SYStoryContentController *storyVC = [[SYStoryContentController alloc]init];
        storyVC.type = model.type;
        storyVC.detailId = model.detailId;
        storyVC.characterId = model.characterId;
        [self.navigationController pushViewController:storyVC animated:YES];
    } else {
        SYStoryTopicDetailController *topicVC = [[SYStoryTopicDetailController alloc]init];
        topicVC.topicId = model.detailId;
        [self.navigationController pushViewController:topicVC animated:YES];
    }
}

#pragma mark ----------------- SCDynamicCellDelegate -------------------
// 点赞
- (void)dynamicCellTapButtonSupportWithIndexPath:(NSIndexPath *)indexPath withSupported:(BOOL)isSupported {
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    SCDynamicModel *model = statusFrame.dynamicModel;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSMutableString *s = [NSMutableString stringWithFormat:model.detailId];
    [s deleteCharactersInRange:NSMakeRange(0, 1)];
    [params setObject:s forKey:@"storyId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentCharacterId] forKey:@"characterId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
    NSString *url = !model.beFav.boolValue ? STORYSUPPORTADD : STORYSUPPORTREMOVE;
    [self showLoading];
    [[SCNetwork shareInstance]postWithUrl:url parameters:params success:^(id responseObject) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValuesForKeysWithDictionary:@{@"userId": [SCCacheTool.shareInstance getCurrentUser],@"characterId": [SCCacheTool.shareInstance getCurrentCharacterId],@"dataArray": [JsonTool stringFromArray:@[model.detailId]]}];
        WS(WeakSelf);
        [[SCNetwork shareInstance] postWithUrl:STORYRECOMMENDDETAIL parameters:params success:^(id responseObject) {
            [WeakSelf hideLoading];
            NSMutableArray *data = [responseObject[@"data"] mutableCopy];
            if (data == [NSNull null] || data.count == 0) {
                return;
            }
            NSDictionary *statusDictionary = data[0];
            model.supportCount = [statusDictionary[@"supportCount"] intValue];
            model.beFav = statusDictionary[@"beFav"];
            
            SCDynamicCell *cell = [WeakSelf.tableView cellForRowAtIndexPath:indexPath];
            cell.dynamicStatusFrame = statusFrame;
        } failure:nil];
    } failure:^(NSError *error) {
        [self hideLoading];
        [SYProgressHUD showError:error.description];
    }];
}

- (void)dynamicCellTapButtonExpandWithIndexPath:(NSIndexPath *)indexPath {
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    SCDynamicModel *model = statusFrame.dynamicModel;
    
    NSMutableArray *storyList = [NSMutableArray arrayWithArray:model.chains];
    
    NSMutableArray *sortArray = [NSMutableArray array];
    [sortArray addObject:[model copyWithZone:nil]];
    int count = storyList.count;
    for (int i=0; i<count; i+=1) {
        [sortArray addObject:[storyList[count - 1 - i] copyWithZone:nil]];
    }
    NSArray *frameArray = [self dynamicFramesWithModels:sortArray];
    SYStoryRetweetController *vc = [[SYStoryRetweetController alloc] init];
    vc.dynamicFrames = frameArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dynamicCellTapButtonCommentWithIndexPath:(NSIndexPath *)indexPath {
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    [self _enterStoryDetailWithModel:statusFrame.dynamicModel];
}

- (void)dynamicCellTapButtonShareWithIndexPath:(NSIndexPath *)indexPath {
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    NSString *spaceId = [SCCacheTool.shareInstance getCurrentSpaceId];
    if (statusFrame.dynamicModel && [statusFrame.dynamicModel.spaceId isEqualToString:spaceId]) {
        SYStoryTransmitController *vc = [[SYStoryTransmitController alloc] init];
        vc.model = statusFrame.dynamicModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SYProgressHUD showError:@"不同世界不能转发"];
    }
}

// 点击头像
- (void)dynamicCellTapButtonIconWithIndexPath:(NSIndexPath *)indexPath {
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    SYFriendHomePageController *vc = [[SYFriendHomePageController alloc] init];
    vc.characterId = statusFrame.dynamicModel.characterId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dynamicCellTapChainCellWithIndexPath:(NSIndexPath *)indexPath withIndex:(int)index {
    SCDynamicStatusFrame *statusFrame = self.dynamicFrames[indexPath.section];
    NSArray *modelArray = statusFrame.dynamicModel.chains;
    if (modelArray && modelArray != [NSNull null] && index < modelArray.count) {
        [self _enterStoryDetailWithModel:modelArray[index]];
    }
}

// 点击更多

- (void)actionMore:(NSNotification*)notification{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray  *titles;
    NSString  *characterId = notification.userInfo[@"characterId"];
    if (characterId.integerValue == [SCCacheTool shareInstance].getCurrentCharacterId.integerValue) {
        titles = @[REPORT,DELETE];
    }else{
        titles = @[REPORT];
    }
    [self addActionTarget:alert titles:titles detailId:notification.userInfo[@"detailId"] rootId:notification.userInfo[@"rootId"]];
    [self addCancelActionTarget:alert title:@"取消"];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles detailId:(NSString*)detailId rootId:(NSString*)rootId{
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if ([title isEqualToString:REPORT]) {
                SCReportController *reportVC = [[SCReportController alloc] init];
                reportVC.detailId = detailId;
                [self.navigationController pushViewController:reportVC animated:YES];
            }
            
            if ([title isEqualToString:@"分享"]) {
                //    [self share_];
                SCCommonShareDashboardView *shareDashboardView = [[SCCommonShareDashboardView alloc] init];
                [shareDashboardView presentViewWithStoryId:detailId];
            }
            if ([title isEqualToString:DELETE]) {
                //调用删除接口
                weakify(self);
                [[SCNetwork shareInstance]postWithUrl:DELETE_STORY parameters:@{@"storyId":rootId} success:^(id responseObject) {
                    [HHTool showResponseObject:responseObject];
                    [weak_self requestData:YES];
                } failure:nil];
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
