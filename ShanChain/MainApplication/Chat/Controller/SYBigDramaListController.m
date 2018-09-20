//
//  SYBigDramaListController.m
//  ShanChain
//
//  Created by krew on 2017/9/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYBigDramaListController.h"
#import "SCMessageCell.h"
#import "SYMessageController.h"
#import "SYBigDramaModel.h"

static NSString * const KSCMessageCellID = @"SCMessageCell";

@interface SYBigDramaListController ()<UITableViewDelegate,UITableViewDataSource>{
    int page;
}

@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArr;

@end

@implementation SYBigDramaListController
#pragma mark -懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView{
    if (! _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCMessageCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KSCMessageCellID];
    }
    return _tableView;
}

#pragma mark -系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    page = 0;
    
    //请求通知列表
    [self requestBigDramaHistoryListData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    /** 结束刷新状态*/
    [self.tableView.mj_header endRefreshing];
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    [self.tableView.mj_footer resetNoMoreData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"大戏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initRefreshView];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -构造方法
- (void)initRefreshView{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self requestBigDramaHistoryListData];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestBigDramaHistoryListData];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
}

- (void)requestBigDramaHistoryListData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"" forKey:@"title"];
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"size"];
    [params setObject:@"createTime,desc" forKey:@"sort"];
    
    [[SCNetwork shareInstance]postWithUrl:HXGAMELIST parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *content = data[@"content"];
            for(NSDictionary *dic in content){
                SYBigDramaModel *dramaModel=[[SYBigDramaModel alloc]init];
                [dramaModel setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:dramaModel];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
}

#pragma mark -UITableViewDataSource
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCMessageCell *cell = (SCMessageCell *)[tableView dequeueReusableCellWithIdentifier:KSCMessageCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SYBigDramaModel *model = self.dataArr[indexPath.row];
    SYMessageController *chatController = [[SYMessageController alloc] initWithConversationChatter:model.groupId conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
