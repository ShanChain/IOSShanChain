//
//  SYStoryTopicDetailController.m
//  ShanChain
//
//  Created by krew on 2017/9/4.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryTopicDetailController.h"
#import "SYTopDetailHeadView.h"
#import "SCDynamicCell.h"
#import "SCDynamicStatusFrame.h"

@interface SYStoryTopicDetailController ()<SYStoryListDelegate>

@property (strong, nonatomic) SYTopDetailHeadView *headView;

@end

@implementation SYStoryTopicDetailController

- (void)initFromRnData {
    if (self.rnParams != nil) {
        NSDictionary *rnData = [JsonTool dictionaryFromString:self.rnParams];
        NSDictionary *data = [rnData objectForKey:@"data"];
        if ([data objectForKey:@"topicId"]) {
            self.topicId = [NSString stringWithFormat:@"%d", [data objectForKey:@"topicId"]];
        }
    }
}

- (void)layoutUI {
    [super layoutUI];

    [self initFromRnData];
    self.title = @"话题详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SYTopDetailHeadView *headView = [[SYTopDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    headView.hidden = YES;
    self.tableView.tableHeaderView = headView;
    self.headView = headView;

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self requestTopicDetail];
}

- (NSArray *)dynamicFramesWithModels:(NSArray *)models {
    NSMutableArray *array = [NSMutableArray array];
    for (SCDynamicModel *model in models) {
        SCDynamicStatusFrame *statusFrame = [[SCDynamicStatusFrame alloc]init];
        model.showChain = NO;
        model.showFloor = NO;
        statusFrame.dynamicModel = model;
        [array addObject:statusFrame];
    }
    return array;
}

- (void)requestTopicDetail {
    if (!self.topicId) {
        [SYProgressHUD showError:@"话题信息错误"];
        return;
    }
    WS(WeakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableString *topicId = [[NSMutableString alloc] initWithString: self.topicId];
    if ([topicId rangeOfString:@"t"].location != NSNotFound) {
        [topicId deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    [params setObject:topicId forKey:@"topicId"];
    [[SCNetwork shareInstance] postWithUrl:STORYTOPICQUERYBYID parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject[@"data"] mutableCopy];
        WeakSelf.headView.hidden = NO;
        WeakSelf.headView.dic = data;
        [WeakSelf.tableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        [SYProgressHUD showError:@"信息获取失败"];
    }];
}

- (void)requestDataHandler {
    if (!self.topicId) {
        [self.tableView mj_endRefreshing];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableString *topicId = [[NSMutableString alloc] initWithString: self.topicId];
    [topicId deleteCharactersInRange:NSMakeRange(0, 1)];
    [params setObject:topicId forKey:@"topicId"];
    [params setValuesForKeysWithDictionary:@{
                                             @"topicId": topicId,
                                             @"characterId": [SCCacheTool.shareInstance getCurrentCharacterId],
                                             @"page": [NSNumber numberWithInt:self.pageIndex],
                                             @"size": [NSNumber numberWithInt:10]
                                             }];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYListByTOPICID parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSArray *dataArr = data[@"content"];
        if (WeakSelf.pageIndex != 0 && dataArr.count == 0) {
            // 如果没有数据当前的页码得恢复
            [WeakSelf.tableView mj_endRefreshing];
            WeakSelf.pageIndex -= 1;
            return;
        }
        NSMutableArray *detailIdArray = [NSMutableArray array];
        for (int i = 0; i < dataArr.count; i ++) {
            NSMutableDictionary *dict = dataArr[i];
            NSString *detailId = dict[@"detailId"];
            [detailIdArray addObject:detailId];
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValuesForKeysWithDictionary:@{
                                                 @"userId": [[SCCacheTool shareInstance] getCurrentUser],
                                                 @"characterId": [[SCCacheTool shareInstance] getCurrentCharacterId],
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
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        SCLog(@"请求数据失败");
    }];
}

@end
