//
//  SYScreenDetailController.m
//  ShanChain
//
//  Created by krew on 2017/9/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScreenDetailController.h"
#import "SYScreenDetailHeadView.h"
#import "SCMessageSettingCell.h"
#import "SYScreenCell.h"
#import "SYNoticeController.h"
#import "SCReportController.h"
#import "SYEditScreenController.h"

#import "SYMessageController.h"
#import "SYScreenInsideController.h"
#import "SYChatController.h"
#import "SYContactsController.h"

static NSString * const KSCMessageSettingCellID = @"SCMessageSettingCell";
static NSString * const KSYScreenCellID = @"SYScreenCell";


@interface SYScreenDetailController ()<UITableViewDelegate,UITableViewDataSource,SYScreenDetailHeadViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView      *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArr;

@property(nonatomic,strong)SYScreenDetailHeadView   *headView;

@property (strong, nonatomic) NSMutableArray *memberArray;

@property (strong, nonatomic) dispatch_semaphore_t semaphoreMember;
@property (strong, nonatomic) dispatch_semaphore_t semaphoreGroup;


@end

@implementation SYScreenDetailController
#pragma mark -懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCMessageSettingCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KSCMessageSettingCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYScreenCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KSYScreenCellID];
    }
    return _tableView;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)HH_requestData{
    [HHTool showChrysanthemum];
    self.memberArray = [NSMutableArray array];
    dispatch_group_t   group = dispatch_group_create();
    dispatch_queue_t   queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self requestGroupInfoCallBlock:^{
            dispatch_group_leave(group);
        }];
        
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self requestGroupMemberListCallBlock:^{
            dispatch_group_leave(group);
        }];
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self requestMembersInfoCallBlock:^{
            [HHTool dismiss];
        }];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self HH_requestData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arrowMoreAction) name:SYScreenInsideDidArrowClickBtnActionNotication object:nil];
    self.title = @"场景详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self initData];
    
    SYScreenDetailHeadView *headView = [[SYScreenDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225.0/667*SCREEN_HEIGHT)];
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    self.headView = headView;
    
//    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(createScreenViewAction)];
//    [headView addGestureRecognizer:singleTapGesture];
    
    
    UIButton  *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitBtn setTitle:@"离开" forState:0];
    [quitBtn setBackgroundImage:[UIImage imageNamed:@"abs_login_btn_rectangle_default"] forState:0];
    [quitBtn addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:quitBtn];
    NSInteger  bottom = 15;
    if (IS_IPHONE_X) {
        bottom = 47;
    }
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.bottom.equalTo(@(-bottom));
        make.left.equalTo(@15);
        make.height.equalTo(@50);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 构造方法
- (void)requestGroupInfoCallBlock:(dispatch_block_t)callBlock{
    if (!self.groupId) {
        SCLog(@"group info request error for emprty groupId");
        return;
    }
    //  dispatch_semaphore_wait(self.semaphoreGroup, DISPATCH_TIME_FOREVER);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.groupId forKey:@"groupId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance]postWithUrl:HXGROUPQUERY parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if (data != [NSNull null]) {
            [WeakSelf.headView setTitle:data[@"groupName"] withDetail:data[@"groupDesc"]];
            
            NSDictionary *owerDict = data[@"groupOwner"];
            if (owerDict != [NSNull null]) {
                [WeakSelf.memberArray insertObject:owerDict[@"hxUserName"] atIndex:0];
            }
        } else {
            [SYProgressHUD showError:@"获取群信息错误"];
        }
        BLOCK_EXEC(callBlock);
        // dispatch_semaphore_signal(WeakSelf.semaphoreGroup);
    } failure:^(NSError *error) {
        BLOCK_EXEC(callBlock);
        SCLog(@"%@",error);
    }];
}

- (void)requestGroupMemberListCallBlock:(dispatch_block_t)callBlock{
    if (!self.groupId) {
        SCLog(@"group member info request error for emprty groupId");
        return;
    }
    // dispatch_semaphore_wait(self.semaphoreMember, DISPATCH_TIME_FOREVER);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.groupId forKey:@"groupId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:HXGROUPMEMBERQUERY parameters:params success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray != [NSNull null]) {
            for (NSDictionary *dict in dataArray) {
                [WeakSelf.memberArray addObject:dict[@"hxUserName"]];
            }
            
            //   dispatch_semaphore_signal(self.semaphoreMember);
        } else {
            [SYProgressHUD showError:@"获取群成员信息错误"];
        }
        BLOCK_EXEC(callBlock);
    } failure:^(NSError *error) {
        BLOCK_EXEC(callBlock);
        SCLog(@"%@",error);
    }];
}

- (void)requestMembersInfoCallBlock:(dispatch_block_t)callBlock{
    //    dispatch_semaphore_wait(self.semaphoreGroup, DISPATCH_TIME_FOREVER);
    //    dispatch_semaphore_wait(self.semaphoreMember, DISPATCH_TIME_FOREVER));
    if (!self.memberArray.count) {
        SCLog(@"group member detail info request error for emprty arrayHX");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JsonTool stringFromArray:self.memberArray] forKey:@"jArray"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:HXUSERQUERYBATCH parameters:params success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray != [NSNull null]) {
            [WeakSelf.headView updateMemberList:dataArray];
        } else {
            [SYProgressHUD showError:@"获取群成员信息错误"];
        }
        //        dispatch_semaphore_signal(WeakSelf.semaphoreMember);
        //        dispatch_semaphore_signal(WeakSelf.semaphoreGroup);
        BLOCK_EXEC(callBlock);
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
        BLOCK_EXEC(callBlock);
    }];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:RGB(212, 0, 0) forState:UIControlStateNormal];
        }
    }
}

- (void)initData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"消息提醒" forKey:@"name"];
    [dict setObject:@"是" forKey:@"isOn"];
    [self.dataArr addObject:dict];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"对话置顶" forKey:@"name"];
    [dict1 setObject:@"是" forKey:@"isOn"];
    [self.dataArr addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"新人进入需要验证" forKey:@"name"];
    [dict2 setObject:@"是" forKey:@"isOn"];
    [self.dataArr addObject:dict2];
}

#pragma mark -UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
    //3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCMessageSettingCell *cell = (SCMessageSettingCell *)[tableView dequeueReusableCellWithIdentifier:KSCMessageSettingCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dic = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
//    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    quitBtn.frame = CGRectMake(KSCMargin, 60, SCREEN_WIDTH - 2 * KSCMargin, 40);
//    [quitBtn setBackgroundImage:[UIImage imageNamed:@"abs_drama_btn_determine_default"] forState:UIControlStateNormal];
//    [quitBtn setTitle:@"离开" forState:UIControlStateNormal];
//    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [quitBtn addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
//    [v1 addSubview:quitBtn];
//    return v1;
//}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
    //120;
}

- (void)quitAction{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"离开" message:@"确定要离开吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        // 获取当前用户环信ID
        NSString *owerHXID = [SCCacheTool.shareInstance getCacheValueInfoWithUserID:[SCCacheTool.shareInstance getCurrentUser] andKey:CACHE_HX_USER_NAME];
        [params setObject:owerHXID forKey:@"username"];
        [params setObject:self.groupId forKey:@"groupId"];
        [HHTool showChrysanthemum];
        [[SCNetwork shareInstance] postWithUrl:HXGROUPMEMBERREMOVE parameters:params success:^(id responseObject) {
            [HHTool dismiss];
            [HHTool showResponseObject:responseObject];
            SYChatController  *chatVC = nil;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SYChatController class]]) {
                    chatVC = (SYChatController*)vc;
                    [self.navigationController popToViewController:chatVC animated:YES];
                    [chatVC tableViewDidTriggerHeaderRefresh];
                }else if ([vc isKindOfClass:[SYContactsController class]]){
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
        } failure:nil];
    }
}

#pragma mark - SYScreenDetailHeadViewDelegate
- (void)screenDetailHeadViewNoticeBtnAction{
    SYNoticeController *noticeVC = [[SYNoticeController alloc]init];
    [self.navigationController pushViewController:noticeVC animated:YES];
}

- (void)createScreenViewAction{
#pragma Todo 权限暂时不做
        SYEditScreenController *editVC = [[SYEditScreenController alloc]init];
        [self.navigationController pushViewController:editVC animated:YES];
}

- (void)arrowMoreAction{
    //    SYScreenInsideController *insideVC = [[SYScreenInsideController alloc]init];
    //    [self.navigationController pushViewController:insideVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
