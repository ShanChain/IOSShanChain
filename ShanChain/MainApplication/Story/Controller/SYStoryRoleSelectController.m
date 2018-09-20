//
//  SYStoryRoleSelectController.m
//  ShanChain
//
//  Created by krew on 2017/9/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRoleSelectController.h"
#import "SYStoryRoleSelectCell.h"
#import "SCSearchController.h"
#import "SYAuxiliaryAddController.h"
#import "SYCharacterModel.h"

static NSString * const KSYStoryRoleSelectCellID = @"SYStoryRoleSelectCell";

@interface SYStoryRoleSelectController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController    *searchController;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *searchListArr;

@end

@implementation SYStoryRoleSelectController
#pragma mark -懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)searchListArr{
    if (!_searchListArr) {
        _searchListArr = [NSMutableArray array];
    }
    return _searchListArr;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT-kNavStatusBarHeight);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYStoryRoleSelectCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SYStoryRoleSelectCell class])];
    }
    return _tableView;
}

#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestSpaceCharacterList];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查找角色";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addAction) image:@"abs_find_btn_addto_default" highImage:@"abs_find_btn_addto_default"];

    [self.view addSubview:self.tableView];
    
}

#pragma mark -构造方法
- (void)addAction{
    SYAuxiliaryAddController *vc = [[SYAuxiliaryAddController alloc] init];
    vc.type = SYAuxiliaryAddTypeRole;
    vc.spaceId = self.spaceId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestSpaceCharacterList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.spaceId) forKey:@"spaceId"];
    
    [[SCNetwork shareInstance]postWithUrl:STORYCHARACTERMODELQUERYSPACEID parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:SC_COMMON_SUC_CODE]) {
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *content = data[@"content"];
            for(NSDictionary *dic in content){
                SYCharacterModel *characterModel=[[SYCharacterModel alloc]init];
                [characterModel setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:characterModel];
            }
            [self.self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
}

-(void)setupUI{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
//    _searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
//    _searchController.obscuresBackgroundDuringPresentation = YES;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _searchController.searchBar;
}


#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchListArr count];
    } else {
        return [self.dataArr count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYStoryRoleSelectCell *cell = (SYStoryRoleSelectCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYStoryRoleSelectCell class])forIndexPath:indexPath];
    if (self.searchController.active) {
        cell.model = self.searchListArr[indexPath.row];
    } else {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    searchController.searchBar.showsCancelButton = YES;
    for (id searchbuttons in [[searchController.searchBar subviews][0] subviews]) //只需在此处修改即可
        
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitle:@"返回"forState:UIControlStateNormal];
            [cancelButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    SCLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS \'%@\'", searchString];
    if (self.searchListArr) {
        [self.searchListArr removeAllObjects];
    }
    //过滤数据
    self.searchListArr= [NSMutableArray arrayWithArray:[_dataArr filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController{
    SCLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController{
    SCLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    SCLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    SCLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController{
    SCLog(@"presentSearchController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
