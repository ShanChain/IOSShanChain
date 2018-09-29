//
//  SYStoryMarkController.m
//  ShanChain
//
//  Created by krew on 2017/8/24.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryMarkController.h"
#import "SYMarkModel.h"
#import "SYmarkCollectionViewCell.h"
#import "SYMarkCollection2Cell.h"
#import "SYStoryMarkFavoriteCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SYStoryRoleController.h"
#import "SYStoryController.h"
#import "SYAuxiliaryAddController.h"

static NSString * const SYmarkCollectionViewCelID = @"SYmarkCollectionViewCel";
static NSString * const SYMarkCollectionC2ellID = @"SYMarkCollection2Cell";
static NSString * const SYStoryMarkFavoriteCellID = @"SYStoryMarkFavoriteCellID";
static NSString * const SYStoryMarkFavoriteHeaderID = @"SYStoryMarkFavoriteHeaderID";

@interface SYStoryMarkController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate>{
}

@property (assign, atomic) int pageIndex;
@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (strong, nonatomic) UICollectionView *favoriteCollectonView;

@property (strong, nonatomic) UIView       *headView;
@property (strong, nonatomic) UIButton    *titleButton;
@property (strong, nonatomic) UISearchBar  *searchBar;
@property (strong, nonatomic) UITextField  *textField;

@property (strong, nonatomic) NSMutableArray *favoriteArray;
@property (strong, nonatomic) NSMutableArray *searchArray;

@property (strong, nonatomic) NSMutableArray *spaceArr;
@end

@implementation SYStoryMarkController

#pragma mark -懒加载
- (NSMutableArray *)spaceArr{
    if (!_spaceArr) {
        _spaceArr = [NSMutableArray array];
    }
    return _spaceArr;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)favoriteArray {
    if (!_favoriteArray) {
        _favoriteArray = [NSMutableArray array];
    }
    return _favoriteArray;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(KSCMargin, 7, SCREEN_WIDTH - 2 * KSCMargin, 30))];
        searchBar.placeholder = @"  搜索世界";
        searchBar.delegate = self;
        // 样式
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [searchBar setImage:[UIImage imageNamed:@"abs_therrbody_icon_search_default"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        // ** 自定义searchBar的样式 **
        searchBar.showsSearchResultsButton = YES;
        for (UIView* subview  in [searchBar.subviews firstObject].subviews) {
            // 打印出两个结果:
            /*
             UISearchBarBackground
             UISearchBarTextField
             */
            if ([subview isKindOfClass:[UITextField class]]) {
                self.textField = (UITextField*)subview;
                // leftView就是放大镜
                // searchField.leftView=nil;
                // 删除searchBar输入框的背景
                [self.textField setBackground:nil];
                [self.textField setBorderStyle:UITextBorderStyleNone];
                self.textField.backgroundColor = RGB(238, 238, 238);
                // 设置圆角
                self.textField.layer.cornerRadius = 15;
                self.textField.layer.masksToBounds = YES;
                break;
            }
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 5)];
        lineView.backgroundColor = RGB(238, 238, 238);
        [_headView addSubview:lineView];
        
        self.searchBar = searchBar;
        [_headView addSubview:searchBar];
        
        [self.view addSubview:_headView];
    }
    return _headView;
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 47) collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.showsVerticalScrollIndicator = true;
        _contentCollectionView.showsHorizontalScrollIndicator = FALSE;
        _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [_contentCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYmarkCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:SYmarkCollectionViewCelID];
        [_contentCollectionView registerClass:SYStoryMarkFavoriteCell.class forCellWithReuseIdentifier:SYStoryMarkFavoriteCellID];
        [_contentCollectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SYStoryMarkFavoriteHeaderID];
    }
    
    return _contentCollectionView;
}

- (UICollectionView *)favoriteCollectonView {
    if (!_favoriteCollectonView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60, 60);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _favoriteCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70) collectionViewLayout:layout];
        _favoriteCollectonView.backgroundColor = [UIColor whiteColor];
        _favoriteCollectonView.delegate = self;
        _favoriteCollectonView.dataSource = self;
        _favoriteCollectonView.showsVerticalScrollIndicator = false;
        _favoriteCollectonView.showsHorizontalScrollIndicator = true;
        _favoriteCollectonView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _favoriteCollectonView.tag = 3000;
        
        [_favoriteCollectonView registerNib:[UINib nibWithNibName:NSStringFromClass([SYMarkCollection2Cell class]) bundle:nil] forCellWithReuseIdentifier:SYMarkCollectionC2ellID];
    }
    return _favoriteCollectonView;
}

#pragma mark -系统方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];

    [self.contentCollectionView.mj_header beginRefreshing];
}

- (void)initRefreshView {
    WS(WeakSelf);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [WeakSelf requestSpaceFavoriteList];
        WeakSelf.pageIndex = 0;
        if ([WeakSelf.searchBar.text isNotBlank]) {
            [WeakSelf requestSearchList];
        } else {
            [WeakSelf requestSpaceList];
        }
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WeakSelf.pageIndex += 1;
        if ([WeakSelf.searchBar.text isNotBlank]) {
            [WeakSelf requestSearchList];
        } else {
            [WeakSelf requestSpaceList];
        }
    }];
    
    self.contentCollectionView.mj_header = header;
    self.contentCollectionView.mj_footer = footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBar];
    
    [self headView];
    
    [self.view addSubview:self.contentCollectionView];
    
    [self initRefreshView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.textField resignFirstResponder];
}

#pragma mark -构造方法
- (void)setNavigationBar {
    self.navigationItem.leftBarButtonItems = @[];
    
    NSString *spaceName = [[SCCacheTool shareInstance] getCurrentSpaceName];
    spaceName = spaceName.length <= 10 ? spaceName : [[spaceName substringToIndex:9] stringByAppendingString:@"..."];
    if (spaceName || ![spaceName isNotBlank]) {
        _titleButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(100, 10.0/667*SCREEN_HEIGHT, SCREEN_WIDTH - 200, 25.0/667*SCREEN_HEIGHT);
        [_titleButton setTitle:spaceName forState:UIControlStateNormal];
        [_titleButton setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"abs_therrbody_btn_putaway_default"] forState:UIControlStateNormal];
        CGFloat imageViewWidth = CGRectGetWidth(_titleButton.imageView.frame);
        CGFloat titleLabelWidth = CGRectGetWidth(_titleButton.titleLabel.frame);
        _titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageViewWidth - 8, 0, imageViewWidth + 8);
        _titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleLabelWidth + 8, 0, -titleLabelWidth - 8);
        
        [_titleButton addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _titleButton;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(createSpaceAction) image:@"abs_find_btn_addto_default" highImage:@"abs_find_btn_addto_default"];
    } else {
         self.title = @"选择新世界";
    }
}

- (void)createSpaceAction {
    SYAuxiliaryAddController *addTimeVC = [[SYAuxiliaryAddController alloc] init];
    addTimeVC.type = SYAuxiliaryAddTypeSpace;
    [self.navigationController pushViewController:addTimeVC animated:YES];
}

-(void)titleBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark ----------- request data -----------
- (void)requestSpaceFavoriteList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[SCCacheTool.shareInstance getCurrentUser] forKey:@"userId"];

    [[SCNetwork shareInstance]postWithUrl:STORYSPACELISTFAVORITE parameters:params success:^(id responseObject) {
            NSMutableDictionary *data = responseObject[@"data"];
            NSArray *contentArray = data[@"content"];
            [self.favoriteArray removeAllObjects];
        
            for(NSDictionary *dic in contentArray){
                SYMarkModel *markModel=[[SYMarkModel alloc] init];
                [markModel setValuesForKeysWithDictionary:dic];
                [self.favoriteArray addObject:markModel];
            }
            
            [self.contentCollectionView reloadData];
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];

}

- (void)requestSpaceList {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:@{@"page":[NSNumber numberWithInt:self.pageIndex], @"size":[NSNumber numberWithInt:10]}];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:ALL_SPACE parameters:params success:^(id responseObject) {
        NSMutableDictionary *data = responseObject[@"data"];
        NSArray *contentArray = data[@"content"];
        if (WeakSelf.pageIndex == 0) {
            [WeakSelf.searchArray removeAllObjects];
        } else {
            if (data.count == 0) {
                // 如果没有数据当前的页码得恢复
                WeakSelf.pageIndex -= 1;
            }
        }
        for(NSDictionary *dic in contentArray){
            SYMarkModel *markModel=[[SYMarkModel alloc] init];
            [markModel setValuesForKeysWithDictionary:dic];
            [WeakSelf.searchArray addObject:markModel];
        }
        
        [WeakSelf.contentCollectionView reloadData];
        [WeakSelf.contentCollectionView mj_endRefreshing];
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
        [WeakSelf.contentCollectionView mj_endRefreshing];
    }];
}

- (void)requestSearchList {
    if (![self.searchBar.text isNotBlank]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.searchBar.text forKey:@"name"];
    WS(WeakSelf);
    [[SCNetwork shareInstance] postWithUrl:STORYSPACELISTBYNAME parameters:params success:^(id responseObject) {
        NSMutableDictionary *data = responseObject[@"data"];
        NSArray *contentArray = data[@"content"];
        if (WeakSelf.pageIndex == 0) {
            [WeakSelf.searchArray removeAllObjects];
        } else {
            if (contentArray.count == 0) {
                // 如果没有数据当前的页码得恢复
                WeakSelf.pageIndex -= 1;
            }
        }
        
        for (NSDictionary *dic in contentArray) {
            SYMarkModel *markModel=[[SYMarkModel alloc] init];
            [markModel setValuesForKeysWithDictionary:dic];
            [WeakSelf.searchArray addObject:markModel];
        }
        
        [WeakSelf.contentCollectionView reloadData];
        [WeakSelf.contentCollectionView mj_endRefreshing];
    } failure:^(NSError *error) {
        [WeakSelf.contentCollectionView mj_endRefreshing];
        SCLog(@"%@",error);
    }];
}

#pragma mark ------ UICollection Delegate -----------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == 3000) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 3000) {
        return _favoriteArray.count;
    } else if (section == 1) {
        return _searchArray.count;
    } else {
        return _favoriteArray.count ? 1 : 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 3000) {
        SYMarkCollection2Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMarkCollectionC2ellID forIndexPath:indexPath];
        cell.model = self.favoriteArray[indexPath.item];
        return cell;
    } else if (indexPath.section == 1) {
        SYmarkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYmarkCollectionViewCelID forIndexPath:indexPath];
        cell.markModel = self.searchArray[indexPath.item];
        return cell;
    } else {
        SYStoryMarkFavoriteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYStoryMarkFavoriteCellID forIndexPath:indexPath];
        [self.favoriteCollectonView removeFromSuperview];
        [cell addSubview:self.favoriteCollectonView];
        [self.favoriteCollectonView reloadData];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYStoryRoleController *vc = [[SYStoryRoleController alloc] init];
    SYMarkModel *m;
    if (collectionView.tag == 3000) {
        m = _favoriteArray[indexPath.item];
        vc.name = m.name;
        vc.intro = m.intro;
        vc.slogan = m.slogan;
        vc.bgPic = m.background;
        vc.spaceId = m.spaceId;
        vc.isFavorite = YES;
    } else {
        m = _searchArray[indexPath.item];
        vc.name = m.name;
        vc.intro = m.intro;
        vc.slogan = m.slogan;
        vc.bgPic = m.background;
        vc.spaceId = m.spaceId;
        
        for (SYMarkModel *model in self.favoriteArray) {
            if (model.spaceId == m.spaceId) {
                vc.isFavorite = YES;
            }
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 3000) {
        return CGSizeMake(60, 60);
    } else if (indexPath.section == 1) {
        CGFloat itemWidth = (self.view.frame.size.width - 15 * 3)/2;
        return  CGSizeMake(itemWidth, itemWidth * 8 / 7);
    } else {
        return CGSizeMake(self.view.frame.size.width, 70);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 3000) {
       return UIEdgeInsetsMake(0, 10, 0, 10);
    } else {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView.tag == 0 &&  section == 0 && self.favoriteArray.count) {
        return CGSizeMake(SCREEN_WIDTH, 40);
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //从缓存中获取 Headercell
    UICollectionReusableView *cell;
    if (kind == UICollectionElementKindSectionHeader) {
       cell = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SYStoryMarkFavoriteHeaderID forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KSCMargin, 0, 100, 40)];
        label.text = @"收藏";
        label.textColor = RGB(102, 102, 102);
        [cell addSubview:label];
    }

    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.pageIndex = 0;
    if ([self.searchBar.text isNotBlank]) {
        [self requestSearchList];
    } else {
        [self requestSpaceList];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText == @"\n") {
        self.pageIndex = 0;
        if ([self.searchBar.text isNotBlank]) {
            [self requestSearchList];
        } else {
            [self requestSpaceList];
        }
    }
}

@end
