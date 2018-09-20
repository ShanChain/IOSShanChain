//
//  SYNoticeController.m
//  ShanChain
//
//  Created by krew on 2017/9/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYNoticeController.h"
#import "SYNoticeModel.h"
#import "SYNoticeCell.h"
#import "SYAddNoticeController.h"
#import "SYNoticeDetailController.h"

static NSString * const KSYNoticeCellID = @"SYNoticeCell";

@interface SYNoticeController()<UITableViewDelegate,UITableViewDataSource>{
    int page;
}

@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArr;

@end

@implementation SYNoticeController
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYNoticeCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KSYNoticeCellID];
    }
    return _tableView;
}

#pragma mark -系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    page = 0;
    
    //请求通知列表
    [self requestNoticeList];
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
    
    self.title = @"公告";
    
    [self initRefreshView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreAction) image:@"abs_home_btn_more_default" highImage:@"abs_home_btn_more_default"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -构造方法
- (void)initRefreshView{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self requestNoticeList];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestNoticeList];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
}

- (void)requestNoticeList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"32404160970754" forKey:@"groupId"];
    [params setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"size"];
    [params setObject:@"createTime,desc" forKey:@"sort"];
//    //   [params setObject:@"hello" forKey:@"token"];
    
    [[SCNetwork shareInstance]postWithUrl:HXGROUPNOTICEGET parameters:params success:^(id responseObject) {
        [self.dataArr removeAllObjects];
        if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
            NSArray *data = responseObject[@"data"];
            if ([data count] > 0) {
                for(NSDictionary *dic in data){
                    SYNoticeModel *noticeModel=[[SYNoticeModel alloc]init];
                    [noticeModel setValuesForKeysWithDictionary:dic];
                    [_dataArr addObject:noticeModel];
                }
                [self.tableView reloadData];
            }else{
                [SYProgressHUD showError:@"暂时无公告"];
                return ;
            }
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
//    if ([APIClient networkType] > 0) {
//        [API getHXGroupNoticeListWithParams:params cb:^(ApiRequestStatusCode requestStatusCode, id JSON) {
//            switch (requestStatusCode) {
//                case ApiRequestOK: {
//                    [self.dataArr removeAllObjects];
//                    NSInteger code= [JSON[@"code"]integerValue];
//                    NSArray *data = JSON[@"data"];
//                    switch (code) {
//                        case COMMON_SUC_CODE:{
//                            if ([data count] > 0) {
//                                for(NSDictionary *dic in data){
//                                    SYNoticeModel *noticeModel=[[SYNoticeModel alloc]init];
//                                    [noticeModel setValuesForKeysWithDictionary:dic];
//                                    [_dataArr addObject:noticeModel];
//                                }
//                                [self.tableView reloadData];
//                            }else{
//                                [SYProgressHUD showError:@"暂时无公告"];
//                                return ;
//                            }
//                            
//                        }
//                            break;
//                    }
//                    break;
//                }
//                case ApiRequestErr:
//                    [SYProgressHUD hideHUD];
//                    [SYProgressHUD showError:kErrTip];
//                    break;
//                case ApiRequestNotReachable:
//                    [SYProgressHUD hideHUD];
//                    [SYProgressHUD showError:kNotReachableTip];
//                    break;
//            }
//        }];
//    }else{
//        [SYProgressHUD showError:kNotReachableTip];
//        return;
//    }
}

- (void)moreAction{
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *titles = @[ @"添加公告"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

- (void)addActionTarget:(UIAlertController *)alertController titles:(NSString *)titles{
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           if ([title isEqualToString:@"添加公告"]) {
                                                               SYAddNoticeController *addVC = [[SYAddNoticeController alloc]init];
                                                               [self.navigationController pushViewController:addVC animated:YES];
                                                           }
                                                       }];
        [action setValue:RGB(0, 118, 255) forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                   }];
    [action setValue:RGB(0, 118,255) forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:RGB(212, 0, 0) forState:UIControlStateNormal];
        }
    }
}

#pragma mark -UITableViewDataSource
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SYNoticeCell *cell = (SYNoticeCell *)[tableView dequeueReusableCellWithIdentifier:KSYNoticeCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SYNoticeDetailController *noticeVC = [[SYNoticeDetailController alloc]init];
    [self.navigationController pushViewController:noticeVC animated:YES]; 
}

//让tableView可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    SYNoticeModel *model = self.dataArr[indexPath.row];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(model.id) forKey:@"id"];
        
        [[SCNetwork shareInstance]postWithUrl:HXGROUPNOTICEDELETE parameters:params success:^(id responseObject) {
            if ([responseObject[@"code"]isEqualToString:SC_COMMON_SUC_CODE]) {
                [self requestNoticeList];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            SCLog(@"%@",error);
        }];
        
    }];
    deleteRowAction.backgroundColor = RGB(254, 56, 36);
    return @[deleteRowAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
