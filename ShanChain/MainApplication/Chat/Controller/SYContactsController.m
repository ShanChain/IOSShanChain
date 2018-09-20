//
//  SYContactsController.m
//  ShanChain
//
//  Created by krew on 2017/9/11.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYContactsController.h"
#import "SCContactFriendCell.h"
#import "SYContactsModel.h"
#import "SYScreenMessageCell.h"
#import "SYMessageController.h"

static NSString *const kSCContactFriendCellID = @"SCContactFriendCell";
static NSString *const KSYScreenMessageCellID = @"SYScreenMessageCell";

@interface SYContactsController ()

@property   (nonatomic,strong) UITableView          *tableView;
@property   (nonatomic,strong) NSMutableArray       *dataArr;
@property   (nonatomic,strong) NSMutableArray       *dataArr1;
@property   (nonatomic,strong) NSMutableArray       *dataArr2;
@property   (nonatomic,strong) NSMutableArray       *dataArr3;
// for control group folder
@property (strong, nonatomic) NSMutableDictionary *unFoldDict;

@end

@implementation SYContactsController

- (NSMutableDictionary *)unFoldDict {
    if (!_unFoldDict) {
        _unFoldDict = [NSMutableDictionary dictionary];
    }
    
    return _unFoldDict;
}

#pragma mark -懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)dataArr1{
    if (!_dataArr1) {
        _dataArr1 = [NSMutableArray array];
    }
    return _dataArr1;
}

- (NSMutableArray *)dataArr2{
    if (!_dataArr2) {
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
}

- (NSMutableArray *)dataArr3{
    if (!_dataArr3) {
        _dataArr3 = [NSMutableArray array];
    }
    return _dataArr3;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCContactFriendCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SCContactFriendCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYScreenMessageCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SYScreenMessageCell class])];
    }
    return _tableView;
}

#pragma mark -系统方法
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /** 结束刷新状态*/
    [self.tableView mj_endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"联系人";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initRefreshView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -构造方法
- (void)initRefreshView{
    WS(WeakSelf);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [WeakSelf requestMyFocusList];
        [WeakSelf requestMyGroupList];
    }];
    
    self.tableView.mj_header = header;
}

- (void)requestMyGroupList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[SCCacheTool shareInstance] getCurrentCharacterId] forKey:@"characterId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance]postWithUrl:HXGROUPMYGROUP parameters:params success:^(id responseObject) {
        NSArray *data = responseObject[@"data"];
        [WeakSelf.dataArr3 removeAllObjects];
        for(NSDictionary *dic in data){
            SYMyGroupModel *groupModel=[[SYMyGroupModel alloc]init];
            [groupModel setValuesForKeysWithDictionary:dic];
            [WeakSelf.dataArr3 addObject:groupModel];
        }
        [WeakSelf.tableView reloadData];
        [WeakSelf.tableView mj_endRefreshing];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        [SYProgressHUD showError:@"加载失败"];
    }];
}

- (void)requestMyFocusList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
    [params setObject:@"0" forKey:@"type"];
    
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYFOCUSQUERY parameters:params success:^(id responseObject) {
        [WeakSelf.dataArr removeAllObjects];
        [WeakSelf.dataArr1 removeAllObjects];
        [WeakSelf.dataArr2 removeAllObjects];
        
        NSArray *data = responseObject[@"data"];
        for(NSDictionary *dic in data){
            SYFocusModel *funsModel=[[SYFocusModel alloc]init];
            [funsModel setValuesForKeysWithDictionary:dic];
            int type = [dic[@"type"]intValue];
            switch (type) {
                case 1:
                    [WeakSelf.dataArr addObject:funsModel];
                    break;
                case 2:
                    [WeakSelf.dataArr1 addObject:funsModel];
                    break;
                case 3:
                    [WeakSelf.dataArr2 addObject:funsModel];
                    break;
                default:
                    break;
            }
        }
        [WeakSelf.tableView reloadData];
        [WeakSelf.tableView mj_endRefreshing];
    } failure:^(NSError *error) {
        [WeakSelf.tableView mj_endRefreshing];
        [SYProgressHUD showError:@"加载联系人失败"];
        SCLog(@"%@",error);
    }];
}

#pragma mark -------------- UITableViewDataSource ---------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.unFoldDict[[NSNumber numberWithInteger:section]]) {
        return 0;
    }
    if (section == 0) {
        return self.dataArr.count;
    } else if (section == 1){
        return self.dataArr1.count;
    } else if(section == 2){
        return self.dataArr2.count;
    } else {
        return self.dataArr3.count;
    }
}

//将tabview的cell与数据模型绑定起来
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        SCContactFriendCell *cell = (SCContactFriendCell *)[tableView dequeueReusableCellWithIdentifier:kSCContactFriendCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.section == 0) {
            cell.funsModel = self.dataArr[indexPath.row];
        } else if (indexPath.section == 1){
            cell.funsModel  = self.dataArr1[indexPath.row];
        } else {
            cell.funsModel = self.dataArr2[indexPath.row];
        }
        return cell;
    } else {
        SYScreenMessageCell *cell = (SYScreenMessageCell *)[tableView dequeueReusableCellWithIdentifier:KSYScreenMessageCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArr3[indexPath.row];
        return cell;
    }    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section < 3) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        SYFocusModel *model = nil;
        if(indexPath.section == 0) {
            model = self.dataArr[indexPath.row];
        } else if (indexPath.section == 1){
            model  = self.dataArr1[indexPath.row];
        } else {
            model = self.dataArr2[indexPath.row];
        }
        
        if (self.callback != NULL) {
            NSDictionary *dict = @{
                                   @"characterId": [NSString stringWithFormat:@"%ld", model.characterId],
                                   @"headImg": model.headImg,
                                   @"intro": model.intro,
                                   @"name": model.name,
                                   @"type": [NSString stringWithFormat:@"%ld", model.type],
                                   @"modelNo": [NSString stringWithFormat:@"%ld", model.modelNo],
                                   @"userId": [NSString stringWithFormat:@"%ld", model.userId],
                                   };
            self.callback(@[dict]);
            [self.navigationController popViewControllerAnimated:true];
            return;
        }
        
        WS(WeakSelf);
        [params setObject:[JsonTool stringFromArray:@[[NSNumber numberWithLong:model.characterId]]] forKey:@"characterIds"];
        [[SCNetwork shareInstance]postWithUrl:HXUSERLIST parameters:params success:^(id responseObject) {
            NSArray *contentArray = responseObject[@"data"];
            
            NSString *hxUserName = nil;
            for (NSDictionary *dict in contentArray) {
                if ([dict[@"characterId"] longValue] == model.characterId) {
                    hxUserName = dict[@"hxUserName"];
                }
            }

            if (!hxUserName) {
                [SYProgressHUD showError:@"查询用户信息失败"];
                return;
            }
            
            SYMessageController *vc = [[SYMessageController alloc] initWithConversationChatter:hxUserName conversationType:EMConversationTypeChat];
            vc.title = model.name;
            [WeakSelf.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [SYProgressHUD showError:@"查询用户信息失败"];
            SCLog(@"%@", error);
        }];
    } else {
        SYMyGroupModel *groupModel = self.dataArr3[indexPath.row];
        SYMessageController *vc = [[SYMessageController alloc] initWithConversationChatter:groupModel.groupId conversationType:EMConversationTypeGroupChat];
        vc.title = groupModel.groupName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark UITableViewDelegate回调方法
//对hearderView进行编辑
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //首先创建一个大的view，nameview
    NSArray *nameArray = @[@"我的关注",@" 互相关注",@"我的粉丝",@"我的群"];
    
    UIView *nameView=[[UIView alloc] init];
    nameView.backgroundColor = [UIColor whiteColor];
    //将分组的名字nameLabel添加到nameview上
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 20, self.view.frame.size.width, 20)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = RGB(102, 102, 102);
    nameLabel.font = [UIFont systemFontOfSize:14];
    [nameView addSubview:nameLabel];
    nameLabel.text=nameArray[section];
    //添加一个button用于响应点击事件（展开还是收起）
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [nameView addSubview:button];
    button.tag = section;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //将显示展开还是收起的状态通过三角符号显示出来
    UIImageView *head= [[UIImageView alloc] initWithFrame: (self.unFoldDict[[NSNumber numberWithInteger:section]] ? CGRectMake(KSCMargin, 24, 12, 6) : CGRectMake(KSCMargin, 24, 6, 12))];
    head.image = self.unFoldDict[[NSNumber numberWithInteger:section]] ? [UIImage imageNamed:@"abs_contactperson_btn_dropdown_default"] : [UIImage imageNamed:@"abs_meet_btn_enter_default"];
    head.userInteractionEnabled = NO;
    head.tag = section;
    [nameView addSubview:head];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.frame = CGRectMake(SCREEN_WIDTH - KSCMargin - 40, 20, 40, 20);
    if (section == 0) {
        contentLabel.text = [NSString stringWithFormat:@"%d",self.dataArr.count];
    } else if (section == 1) {
        contentLabel.text = [NSString stringWithFormat:@"%d",self.dataArr1.count] ;
    } else if(section == 2) {
        contentLabel.text = [NSString stringWithFormat:@"%d",self.dataArr2.count] ;
    } else {
        contentLabel.text = [NSString stringWithFormat:@"%d",self.dataArr3.count];
    }
    contentLabel.textColor = RGB(102, 102, 102);
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [nameView addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = RGB(238, 238, 238);
    [nameView addSubview:lineView];
    //根据模型里面的展开还是收起变换图片
    SYFocusModel *focus;
    //返回nameView
    return nameView;
}
//设置headerView高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
//设置cell的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//button的响应点击事件
- (void) buttonClicked:(UIButton *) sender {
    //改变模型数据里面的展开收起状态
    if ([self.unFoldDict objectForKey:[NSNumber numberWithInteger:sender.tag]]) {
        [self.unFoldDict removeObjectForKey:[NSNumber numberWithInteger:sender.tag]];
    } else {
        [self.unFoldDict setObject:@1 forKey:[NSNumber numberWithInteger:sender.tag]];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
