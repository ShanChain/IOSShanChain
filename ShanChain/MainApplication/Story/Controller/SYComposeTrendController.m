//
//  SYComposeTrendController.m
//  ShanChain
//
//  Created by krew on 2017/8/30.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYComposeTrendController.h"
#import "SCTopCell.h"
#import "SYComposeTrendModel.h"
#import "SYAuxiliaryAddController.h"
static NSString * const kSCTopCellID = @"SCTopCellID";

@interface SYComposeTrendController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic,strong)UITableView      *tableView;
@property (nonatomic,strong)NSMutableArray   *dataArray;
@property (nonatomic,strong)NSMutableArray   *filterArray;
@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong)NSString *trendString;

@end

@implementation SYComposeTrendController
#pragma mark -懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)filterArray {
    if (!_filterArray) {
        _filterArray = [NSMutableArray array];
    }
    return _filterArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-80)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCTopCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SCTopCell class])];
    }
    return _tableView;
}

#pragma mark -系统方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestTopicListData];
    
    [self setNavigationBar];
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIButton alloc] init]];
    self.navigationItem.leftBarButtonItem = colseItem;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchBar.hidden =YES;
    
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.trendString = @"";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:RGB(102, 102, 102)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -构造方法
- (void)requestTopicListData {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[SCCacheTool.shareInstance getCurrentSpaceId] forKey:@"spaceId"];
    [params setObject:@100 forKey:@"size"];
    [params setObject:@0 forKey:@"page"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:TOPICLISTINSPACE parameters:params success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSMutableArray *contentArray = data[@"content"];
        [WeakSelf.dataArray removeAllObjects];
        [WeakSelf.filterArray removeAllObjects];
        for (NSDictionary *dic in contentArray) {
            SYComposeTrendModel *trendModel=[[SYComposeTrendModel alloc]init];
            [trendModel setValuesForKeysWithDictionary:dic];
            trendModel.title = [NSString stringWithFormat:@"#%@#", trendModel.title];
            [WeakSelf.dataArray addObject:trendModel];
            [WeakSelf.filterArray addObject:trendModel];
        }
        [WeakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
}

-(void)setNavigationBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(KSCMargin, 27, SCREEN_WIDTH -75, 30))];
    searchBar.placeholder = @"  话题";
    searchBar.delegate = self;
    // 样式
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [searchBar setImage:[UIImage imageNamed:@"abs_topic_icon_topic_default"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.navigationItem.hidesBackButton = YES;
    // ** 自定义searchBar的样式 **
    UITextField* searchField = nil;
    // 注意searchBar的textField处于孙图层中
    for (UIView* subview  in [searchBar.subviews firstObject].subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            
            searchField = (UITextField*)subview;
            // leftView就是放大镜
            // searchField.leftView=nil;
            // 删除searchBar输入框的背景
            [searchField setBackground:nil];
            [searchField setBorderStyle:UITextBorderStyleNone];
            searchField.backgroundColor = RGB(246, 246, 246);
            // 设置圆角
            searchField.layer.cornerRadius = 15;
            searchField.layer.masksToBounds = YES;
            break;
        }
    }
    
     self.searchBar = searchBar;
    [self.navigationController.view addSubview: searchBar];
}

- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text isNotBlank]) {
        NSString *searchString = searchBar.text;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title CONTAINS \'%@\'", searchString]];
        [self.filterArray removeAllObjects];
        self.filterArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
    } else {
        [self.filterArray removeAllObjects];
        for (SYComposeTrendModel *model in self.dataArray) {
            [self.filterArray addObject:model];
        }
    }
    //刷新表格
    if (!self.filterArray.count) {
        SYComposeTrendModel *model = [[SYComposeTrendModel alloc] init];
        model.isNotExist = YES;
        model.title = [NSString stringWithFormat:@"#%@#", ([searchBar.text isNotBlank] ? searchBar.text : @"")];
        [self.filterArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark -tableView
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCTopCell *cell = (SCTopCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCTopCell class])forIndexPath:indexPath];
    cell.model = self.filterArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SYComposeTrendModel *model = self.filterArray[indexPath.row];
    if (model.isNotExist) {
        SYAuxiliaryAddController *vc = [[SYAuxiliaryAddController alloc] init];
        vc.type = SYAuxiliaryAddTypeTopic;
        NSMutableString *title = [[NSMutableString alloc] initWithString:model.title];
        if (title.length > 2) {
            [title deleteCharactersInRange:NSMakeRange(model.title.length - 1, 1)];
            [title deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        vc.topicName = title;
        
        [self.navigationController pushViewController:vc animated:true];
    } else {
        self.trendString = [self.trendString stringByAppendingString:model.title];
        if (_delegate && [_delegate respondsToSelector:@selector(composeTrendControllerWithText:withTopicId:)]) {
            [_delegate composeTrendControllerWithText:model.title withTopicId:model.topicId];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = RGB(255, 255, 255);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 30)];
    label.text = @"推荐";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = RGB(164, 164, 164);
    [view addSubview:label];
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = RGB(232, 232, 232);
    lineView1.frame = CGRectMake(0, 29, SCREEN_WIDTH, 1);
    [view addSubview:lineView1];
    
    return view;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
