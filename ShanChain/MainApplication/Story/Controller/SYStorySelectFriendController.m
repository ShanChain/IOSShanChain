//
//  SYStorySelectFriendController.m
//  ShanChain
//
//  Created by krew on 2017/8/31.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStorySelectFriendController.h"
#import "SCSeFriendCell.h"
#import "SYMessageController.h"
#import "SYFriend.h"
#import "SYFriendGroup.h"
#import "SYContactGroupModel.h"
#import "SYContactModel.h"

static NSString * const KSCSeFriendCellID = @"SCSeFriendCell";

@interface SYStorySelectFriendController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataGroupArr;

@property (nonatomic,strong )UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *contactGroup;

@property (strong, nonatomic) NSMutableArray *memberArray;

@property (strong, nonatomic) dispatch_semaphore_t semaphoreMember;
@property (strong, nonatomic) dispatch_semaphore_t semaphoreGroup;

@end

@implementation SYStorySelectFriendController
#pragma mark -懒加载
-(NSMutableArray *)dataGroupArr{
    if (!_dataGroupArr) {
        _dataGroupArr = [NSMutableArray array];
    }
    return _dataGroupArr;
}

-(NSMutableArray *)memberArray{
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

- (NSMutableArray *)contactGroup{
    if (!_contactGroup) {
        _contactGroup = [NSMutableArray array];
    }
    return _contactGroup;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight)];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerClass:[SCSeFriendCell class] forCellReuseIdentifier:KSCSeFriendCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -系统方法

- (void)layoutUI {
    self.title = @"选择联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationRightWithName:@"确定" withTarget:self withAction:@selector(sureAction:)];
    
    [self setSearchBar];
    [self tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.type == 1) {
        [self requestGroupList];
    } else if (self.type == 2) {
        [self requestFriendList];
    } else {
        [self requestCharacterList];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.type == 1) {
        [self requestMembersInfo];
    }
}

#pragma mark -构造方法
- (void)requestCharacterList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYCHARACTERMODELLISTSPACEID parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
            NSDictionary *data = responseObject[@"data"];
            if (!data) {
                return ;
            }
            if (![data[@"array"] isKindOfClass:[NSArray class]]) {
                return ;
            }
            NSArray *array = data[@"array"];
            NSMutableArray * groupsArr = [NSMutableArray array];
            for (NSDictionary * dic in array) {
                SYFriendGroup * group = [[SYFriendGroup alloc] init];
                [group setValuesForKeysWithDictionary:dic];
                [groupsArr addObject:group];
            }
            WeakSelf.dataGroupArr = groupsArr;
            [WeakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
}

- (void)requestGroupList {
    self.semaphoreMember = dispatch_semaphore_create(1);
    self.semaphoreGroup = dispatch_semaphore_create(1);
    
    [self requestGroupInfo];
    
    [self requestGroupMemberList];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 构造方法
- (void)requestGroupInfo {
    if (!self.groupId) {
        SCLog(@"group info request error for emprty groupId");
        return;
    }
    dispatch_semaphore_wait(self.semaphoreGroup, dispatch_time(DISPATCH_TIME_NOW, 1000 * NSEC_PER_SEC));
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.groupId forKey:@"groupId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance]postWithUrl:HXGROUPQUERY parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if (data != [NSNull null]) {
            NSDictionary *owerDict = data[@"groupOwner"];
            if (owerDict != [NSNull null]) {
                [WeakSelf.memberArray insertObject:owerDict[@"hxUserName"] atIndex:0];
            }
        } else {
            [SYProgressHUD showError:@"获取群信息错误"];
        }
        dispatch_semaphore_signal(WeakSelf.semaphoreGroup);
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
}

- (void)requestGroupMemberList {
    if (!self.groupId) {
        SCLog(@"group member info request error for emprty groupId");
        return;
    }
    dispatch_semaphore_wait(self.semaphoreMember, dispatch_time(DISPATCH_TIME_NOW, 1000 * NSEC_PER_SEC));
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.groupId forKey:@"groupId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:HXGROUPMEMBERQUERY parameters:params success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray != [NSNull null]) {
            for (NSDictionary *dict in dataArray) {
                [WeakSelf.memberArray addObject:dict[@"hxUserName"]];
            }
            
            dispatch_semaphore_signal(WeakSelf.semaphoreMember);
        } else {
            [SYProgressHUD showError:@"获取群成员信息错误"];
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
}

- (void)requestMembersInfo {
    if (!self.groupId) {
        SCLog(@"group member info request error for emprty groupId");
        return;
    }
    dispatch_semaphore_wait(self.semaphoreGroup, dispatch_time(DISPATCH_TIME_NOW, 1000 * NSEC_PER_SEC));
    dispatch_semaphore_wait(self.semaphoreMember, dispatch_time(DISPATCH_TIME_NOW, 1000 * NSEC_PER_SEC));
    if (!self.memberArray.count) {
        SCLog(@"group member detail info request error for emprty arrayHX");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[JsonTool stringFromDictionary:self.memberArray] forKey:@"jArray"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:HXUSERQUERYBATCH parameters:params success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        if (dataArray != [NSNull null]) {
            [WeakSelf.contactGroup removeAllObjects];
            for(NSDictionary *dict in dataArray) {
                SYContactModel *model = [[SYContactModel alloc] init];
                model.name = dict[@"name"];
                model.headImg = dict[@"headImg"];
                model.hxUserName = dict[@"hxUserName"];
                [WeakSelf.contactGroup addObject:model];
            }
            [WeakSelf.tableView reloadData];
        } else {
            [SYProgressHUD showError:@"获取群成员信息错误"];
        }
        dispatch_semaphore_signal(WeakSelf.semaphoreMember);
        dispatch_semaphore_signal(WeakSelf.semaphoreGroup);
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
}

- (void)requestFriendList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYFOCUSCONTACTS parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSArray *array = data[@"array"];
        NSMutableArray * groupsArr = [NSMutableArray array];
        for (NSDictionary * dic in array) {
            SYContactGroupModel * group = [[SYContactGroupModel alloc] init];
            [group setValuesForKeysWithDictionary:dic];
            [groupsArr addObject:group];
        }
        WeakSelf.contactGroup = groupsArr;
        [WeakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
}

- (void)setSearchBar {
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(KSCMargin, 7, SCREEN_WIDTH - 2 * KSCMargin, 30))];
    searchBar.placeholder = @"  搜索";
    searchBar.delegate = self;
    // 样式
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [searchBar setImage:[UIImage imageNamed:@"abs_therrbody_icon_search_default"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.navigationItem.hidesBackButton = YES;
    // ** 自定义searchBar的样式 **
    UITextField* searchField = nil;
    // 注意searchBar的textField处于孙图层中
    for (UIView* subview in [searchBar.subviews firstObject].subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            searchField = (UITextField*)subview;
            // leftView就是放大镜
            // 删除searchBar输入框的背景
            [searchField setBackground:nil];
            [searchField setBorderStyle:UITextBorderStyleNone];
            searchField.backgroundColor = RGB(238, 238, 238);
            // 设置圆角
            searchField.layer.cornerRadius = 15;
            searchField.layer.masksToBounds = YES;
            break;
        }
    }
    self.searchBar = searchBar;
    [headView addSubview:searchBar];
    
    self.tableView.tableHeaderView = headView;
}

- (void)sureAction:(UIButton *)button {
    if (self.type == 1) {
        NSMutableArray *array = [NSMutableArray array];
        for (SYContactModel *friend in self.contactGroup) {
            if (friend.isSelected) {
                [array addObject:friend];
            }
        }
        if (self.callback != NULL) {
            self.callback(array);
        }
        
        [self.navigationController popViewControllerAnimated:true];
    } else if (self.type == 2){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableArray *array = [NSMutableArray array];
        for (SYContactGroupModel *model in self.contactGroup) {
            for (SYContactModel *friend in model.list) {
                if (friend.isSelected) {
                    [array addObject:[NSNumber numberWithLong:friend.characterId]];
                }
            }
        }
        NSString *t=[JsonTool stringFromArray:array];
        [params setObject:t forKey:@"characterIds"];
        
        WS(WeakSelf);
        [[SCNetwork shareInstance]postWithUrl:HXUSERLIST parameters:params success:^(id responseObject) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *hxArr = [NSMutableArray array];
            for(NSDictionary *dic in data){
                [hxArr addObject:dic[@"hxUserName"]];
            }
            
            if (!hxArr.count) {
                [SYProgressHUD showError:@"联系人信息有误"];
                return;
            }
            NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
            NSDictionary *characterInfo = [SCCacheTool.shareInstance getCharacterInfo];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:hxArr forKey:@"members"];
            [dict setObject:[NSString stringWithFormat:@"%@创建的群", characterInfo[@"name"]] forKey:@"groupname"];
            [dict setObject:[NSString stringWithFormat:@"%@创建的群", characterInfo[@"name"]] forKey:@"desc"];
            [dict setObject:@"" forKey:@"icon_url"];
            [dict setObject:@"true" forKey:@"pub"];
            [dict setObject:@"true" forKey:@"approval"];
            
            NSString *owerHXID = [SCCacheTool.shareInstance getCacheValueInfoWithUserID:[SCCacheTool.shareInstance getCurrentUser] andKey:CACHE_HX_USER_NAME];
            if (!owerHXID) {
                [SYProgressHUD showError:@"建群失败"];
                return;
            }
            [dict setObject:owerHXID forKey:@"owner"];
            [dict setObject:@300 forKey:@"maxusers"];
            [params1 setObject:[JsonTool stringFromDictionary:dict] forKey:@"dataString"];
            [params1 setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
            [[SCNetwork shareInstance]postWithUrl:HXGROUPCREATE parameters:params1 success:^(id responseObject) {
                NSDictionary *data = responseObject[@"data"];
                if (data[@"groupid"]) {
                    if ([WeakSelf.delegate respondsToSelector:@selector(selectFriendWithOpenGroupChat:withGroupName:)]) {
                        [WeakSelf.delegate selectFriendWithOpenGroupChat:data[@"groupid"] withGroupName:[NSString stringWithFormat:@"%@创建的群", characterInfo[@"name"]]];
                    }
                } else {
                    [SYProgressHUD showError:@"建群失败"];
                }
            } failure:nil];
        } failure:nil];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        for (SYFriendGroup *model in self.dataGroupArr) {
            for (SYFriend *friend in model.list) {
                if (friend.isSelected) {
                    [array addObject:@{
                                       @"headImg" : friend.headImg,
                                       @"modelId" : [NSNumber numberWithLong:friend.modelId],
                                       @"name" : friend.name
                                       }];
                }
            }
        }
        if (_delegate && [_delegate respondsToSelector:@selector(selectFriendWithArray:)]) {
            [_delegate selectFriendWithArray:array];
            [self.navigationController popViewControllerAnimated:YES];
        } 
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type == 1) {
        return 1;
    } else if (self.type == 2) {
        return self.contactGroup.count;
    } else {
        return self.dataGroupArr.count;
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 1) {
        return self.contactGroup.count;
    } else if (self.type == 2) {
        SYContactGroupModel *group = self.contactGroup[section];
        return group.list.count;
    } else{
        SYFriendGroup *group = self.dataGroupArr[section];
        return group.list.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCSeFriendCell *cell = (SCSeFriendCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCSeFriendCell class])forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.type == 1) {
        SYContactModel *model = self.contactGroup[indexPath.row];
        cell.model = model;
    } else if (self.type == 2) {
        SYContactGroupModel *group = self.contactGroup[indexPath.section];
        SYContactModel *model = group.list[indexPath.row];
        cell.model = model;
    } else {
        SYFriendGroup *group = self.dataGroupArr[indexPath.section];
        SYFriend *friend  = group.list[indexPath.row];
        cell.fried = friend;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SCSeFriendCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.type == 1) {
        SYContactModel *contacts  = self.contactGroup[indexPath.row];
        contacts.isSelected = !contacts.isSelected;
    } else if (self.type == 2) {
        SYContactGroupModel *group = self.contactGroup[indexPath.section];
        SYContactModel *contacts  = group.list[indexPath.row];
        contacts.isSelected = !contacts.isSelected;
    } else {
        SYFriendGroup *group = self.dataGroupArr[indexPath.section];
        SYFriend * friend  = group.list[indexPath.row];
        friend.isSelected = !friend.isSelected;
    }
    
    [self.tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.type == 1) {
        return @"";
    } else if (self.type) {
        SYContactGroupModel *group = self.contactGroup[section];
        return group.letter;
    } else {
        SYFriendGroup * group = self.dataGroupArr[section];
        return group.letter;
    }
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type == 1) {
        return 0;
    }
    
    return 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
