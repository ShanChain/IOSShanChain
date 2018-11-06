//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "LeftViewController.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"
#import "ShanChain-Swift.h"
#import "SCBaseNavigationController.h"

@interface LeftViewController ()<DUX_UploadUserIconDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy)   UIImageView   *icon;

@end

@implementation LeftViewController
{
    CWTableViewInfo *_tableViewInfo;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Theme_ViewBackgroundColor;
    self.tableView.backgroundColor = Theme_ViewBackgroundColor;
    [self setupHeader];
    [self setupTableView];
    
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 100)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageV];
    

    UIView *layerView = [[UIView alloc]init];
    layerView.layer.shadowOffset = CGSizeMake(0, 7);
    layerView.layer.shadowOpacity = 0.3;
    layerView.layer.shadowRadius = 6;
    [layerView _setCornerRadiusCircle];
    layerView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:layerView];
    [layerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changesIcon)]];
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@50);
        make.width.height.equalTo(@64);
    }];
    
    UIImageView  *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"abs_addanewrole_def_photo_default"];
    _icon = img;
    [layerView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(layerView);
    }];
    [layerView signleDragable];
    [img _setCornerRadiusCircle];
    
    UILabel  *nikeNameLb = [[UILabel alloc]init];
    nikeNameLb.textColor = [UIColor whiteColor];
    nikeNameLb.font = Font(17);
    nikeNameLb.text = @"陈叔爱吃盐焗鸡";
    [self.view addSubview:nikeNameLb];
    [nikeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(layerView).offset(-5);
        make.left.equalTo(layerView.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(self.view.height - 150);
        make.height.equalTo(@25);
    }];
    
    UILabel  *signatureLb = [[UILabel alloc]init];
    signatureLb.textColor = [UIColor whiteColor];
    signatureLb.font = Font(13);
    signatureLb.text = @"一直在努力的路上";
    [self.view addSubview:signatureLb];
    [signatureLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nikeNameLb.mas_bottom).offset(10);
        make.left.equalTo(layerView.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(self.view.height - 150);
        make.height.equalTo(@25);
    }];
    
    
    UIButton  *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"发任务"] forState:0];
    [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nikeNameLb.mas_right).offset(15);
        make.firstBaseline.equalTo(nikeNameLb);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

}

- (void)edit{
    DLog(@"编辑");
}

- (void)changesIcon{
    [UPLOAD_IMAGE showActionSheetInFatherViewController:self imageTag:100 delegate:self];
}
- (void)setupTableView {
    
    _tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:CGRectMake(0, 300, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        NSString *imageName = self.imageArray[i];
        SEL sel = @selector(didSelectCell:indexPath:);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:imageName target:self sel:sel];
        [_tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[_tableViewInfo getTableView]];
    [[_tableViewInfo getTableView] reloadData];
}

#pragma mark - cell点击事件
- (void)didSelectCell:(CWTableViewCellInfo *)cellInfo indexPath:(NSIndexPath *)indexPath {
    
    TaskListContainerViewController *taskVC = [[TaskListContainerViewController alloc]init];
    taskVC.title = @"悬赏任务";
    JCMainTabBarController  *tab = (JCMainTabBarController*)[HHTool mainWindow].rootViewController;
    JCNavigationController *nav = tab.selectedViewController;
    if (!nav) {
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            // 我的钱包
            
            break;
        case 1:
            // 我的任务
        {
            
            [nav.topViewController.navigationController pushViewController:taskVC animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            
            
            break;
        case 2:
            //我的消息
            
            break;
        case 3:
            // 我的收藏
            
            break;
        case 4:
            //我的认证
            
            break;
        default:
            break;
    }
    
}

- (void)showAlterView {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"hello world!" message:@"hello world!嘿嘿嘿" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"😂😄" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Getter
- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",
                        @"personal_myservice_icons",
                        @"personal_news_icons",
                        @"personal_order_icons",
                        @"personal_preview_icons",
                        @"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"我的钱包",
                        @"我的任务",
                        @"我的消息",
                        @"我的收藏",
                        @"我的认证"];
    }
    return _titleArray;
}

#pragma mark -- DUX_UploadUserIconDelegate

-(void)uploadImageToServerWithImage:(UIImage *)image Tag:(NSInteger)tag{
    _icon.image = image;
}


@end
