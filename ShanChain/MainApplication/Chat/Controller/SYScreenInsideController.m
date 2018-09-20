//
//  SYScreenInsideController.m
//  ShanChain
//
//  Created by krew on 2017/9/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScreenInsideController.h"
#import "SYScreenInsideCell.h"

static NSString  *const KSYScreenInsideCellID = @"SYScreenInsideCell";

@interface SYScreenInsideController ()<UITableViewDelegate,UITableViewDataSource,SYScreenInsideCellDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property(nonatomic,strong)NSMutableArray       *dataArr;
@property(nonatomic,strong)UITableView          *tableView;

@property(nonatomic,strong)NSMutableArray       *dataListArr;

@property (strong, nonatomic)  UISearchController *searchController;
@property(nonatomic,strong)NSIndexPath *currentIndexPath;

@end

@implementation SYScreenInsideController
#pragma mark -懒加载
- (NSMutableArray *)dataListArr{
    if (!_dataListArr) {
        _dataListArr = [NSMutableArray array];
    }
    return _dataListArr;
}

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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SYScreenInsideCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:KSYScreenInsideCellID];
    }
    return _tableView;
}

#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"场内的人";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    [self setSearcher];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -构造方法
- (void)setSearcher{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = YES;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _searchController.searchBar;
    
}

- (void)initData{
    NSMutableDictionary *dict0 =[NSMutableDictionary dictionary];
    [dict0 setObject:@"abs_addanewrole_def_photo_default" forKey:@"icon"];
    [dict0 setObject:@"智子（No.3）" forKey:@"name"];
    [dict0 setObject:@"叶文杰，哎AA等两人签到”" forKey:@"content"];
    [dict0 setObject:@"普通权限" forKey:@"author"];
    [self.dataArr addObject:dict0];
    
    NSMutableDictionary *dict1 =[NSMutableDictionary dictionary];
    [dict1 setObject:@"on_icon_shanchain_disabled" forKey:@"icon"];
    [dict1 setObject:@"智子（No.3）" forKey:@"name"];
    [dict1 setObject:@"孟晋，Just Do it" forKey:@"content"];
    [dict1 setObject:@"管理员" forKey:@"author"];
    [self.dataArr addObject:dict1];
    
    NSMutableDictionary *dict2 =[NSMutableDictionary dictionary];
    [dict2 setObject:@"dynamic_btn_round_default" forKey:@"icon"];
    [dict2 setObject:@"智子（No.3）" forKey:@"name"];
    [dict2 setObject:@"Follow your heart ,to be number one" forKey:@"content"];
    [dict2 setObject:@"普通权限" forKey:@"author"];
    [self.dataArr addObject:dict2];
    
    NSMutableDictionary *dict3 =[NSMutableDictionary dictionary];
    [dict3 setObject:@"on_icon_shanchain_disabled" forKey:@"icon"];
    [dict3 setObject:@"三体游戏与童话王国" forKey:@"name"];
    [dict3 setObject:@"我应该怎么做" forKey:@"content"];
    [dict3 setObject:@"管理员" forKey:@"author"];
    [self.dataArr addObject:dict3];
}

#pragma mark -UITableViewDataSource
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return self.dataListArr.count;
    }else{
        return self.dataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SYScreenInsideCell *cell = (SYScreenInsideCell *)[tableView dequeueReusableCellWithIdentifier:KSYScreenInsideCellID forIndexPath:indexPath];
    cell.delegate = self;
    self.currentIndexPath = indexPath;
    cell.indexPath = indexPath;
    if (self.searchController.active) {
        cell.dic = self.dataListArr[indexPath.row];
    }else{
        cell.dic = self.dataArr[indexPath.row];
    }
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -SYScreenInsideCellDelegate
- (void)setScreenInsideQuitBtnClicked:(NSIndexPath *)indexPath{
    self.currentIndexPath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"离开"
                                                    message:@"确定要离开吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

//测试UISearchController的执行过程
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
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.dataListArr!= nil) {
        [self.dataListArr removeAllObjects];
    }
    //过滤数据
    self.dataListArr= [NSMutableArray arrayWithArray:[self.dataArr filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
