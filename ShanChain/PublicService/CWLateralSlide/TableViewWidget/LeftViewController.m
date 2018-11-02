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

@interface LeftViewController ()

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

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
    
    [self setupHeader];
    [self setupTableView];
    
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 200)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageV];
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


@end
