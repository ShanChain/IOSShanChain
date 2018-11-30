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
#import "EditPersonalInfoViewController.h"
#import "SCAliyunUploadMananger.h"
#import "MyWalletViewController.h"
#import "NotificationHandler.h"

#define HeaderViewHeight 200

@interface LeftViewController ()<DUX_UploadUserIconDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong)   UIImageView   *icon;

    //阿里云参数
@property(nonatomic,strong)NSDictionary *aliDict;
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
    self.view.backgroundColor = RGB(245, 245, 245);
    [self setupHeader];
    [self setupTableView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // [self.view.superview sendSubviewToBack:self.view];
}

-(void)setIconImage{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString  *headImg = [SCCacheTool shareInstance].characterModel.characterInfo.headImg;
        UIImage *headImage = [UIImage imageFromURLString:headImg];
        headImage = [headImage mc_resetToSize:CGSizeMake(64, 64)];
        headImage = [headImage cutCircleImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (headImg) {
                self.icon.image = headImage;
            }else{
                self.icon.image = [UIImage imageNamed:DefaultAvatar];
            }
        });
    });
}

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, HeaderViewHeight)];
    imageV.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"icon_background"];
    [image mc_resetToSize:CGSizeMake(kCWSCREENWIDTH * 0.75, HeaderViewHeight)];
    imageV.image = image;
    [self.view addSubview:imageV];
    

    UIView *layerView = [[UIView alloc]init];
    layerView.layer.shadowOffset = CGSizeMake(0, 7);
    layerView.layer.shadowOpacity = 0.3;
    layerView.layer.shadowRadius = 6;
    layerView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:layerView];
    [layerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changesIcon)]];
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@50);
        make.width.height.equalTo(@64);
    }];
    [layerView signleDragable];
    
    
    UIImageView  *img = [[UIImageView alloc]init];
    self.icon = img;
    [self setIconImage];
    [layerView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(layerView);
    }];
    img.contentMode = UIViewContentModeCenter;
    [img preventImageViewExtrudeDeformation];
    
    
    UILabel  *nikeNameLb = [[UILabel alloc]init];
    nikeNameLb.textColor = [UIColor whiteColor];
    nikeNameLb.font = Font(17);
    NSString  *name = [SCCacheTool shareInstance].characterModel.characterInfo.name ? :@"暂无昵称";
    nikeNameLb.text = name;
    [self.view addSubview:nikeNameLb];
    [nikeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(layerView).offset(-5);
        make.left.equalTo(layerView.mas_right).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@25);
    }];
    
    UILabel  *signatureLb = [[UILabel alloc]init];
    signatureLb.textColor = [UIColor whiteColor];
    signatureLb.font = Font(13);
    signatureLb.numberOfLines = 0;
    signatureLb.text = [SCCacheTool shareInstance].characterModel.characterInfo.signature ? :@"暂无签名";
    [self.view addSubview:signatureLb];
    [signatureLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nikeNameLb.mas_bottom).offset(20);
        make.left.equalTo(layerView.mas_right).offset(10);
        make.width.right.equalTo(@-40);
        make.height.equalTo(@80);
    }];
    
    
    UIButton  *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"sc_com_icon_edit"] forState:0];
    [editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nikeNameLb.mas_right).offset(15);
        make.firstBaseline.equalTo(nikeNameLb);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

}

- (void)edit{
    [self dismissViewControllerAnimated:YES completion:nil];
    EditPersonalInfoViewController *editVC = [[EditPersonalInfoViewController alloc]init];
    [[self mainNav].topViewController.navigationController pushViewController:editVC animated:YES];
}



- (JCNavigationController*)mainNav{
    JCNavigationController *nav;
    if ([[HHTool mainWindow].rootViewController isKindOfClass:[JCMainTabBarController  class]]) {
        JCMainTabBarController  *tab = (JCMainTabBarController*)[HHTool mainWindow].rootViewController;
        JCNavigationController *navController = tab.selectedViewController;
        nav = navController;
    }else{
        nav = (JCNavigationController*)[HHTool mainWindow].rootViewController;
    }
    
    return nav;
}

- (void)changesIcon{
   
    [UPLOAD_IMAGE showActionSheetInFatherViewController:[self mainNav].topViewController imageTag:100 delegate:self];
    [UPLOAD_IMAGE setDUX_cancelBlock:^{
        [[CWMaskView shareInstance]singleTap];
    }];
}
- (void)setupTableView {
    
    _tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:CGRectMake(0, HeaderViewHeight, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-HeaderViewHeight) style:UITableViewStylePlain];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        NSString *imageName = self.imageArray[i];
        SEL sel = @selector(didSelectCell:indexPath:);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:imageName target:self sel:sel];
        [_tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[_tableViewInfo getTableView]];
    [_tableViewInfo getTableView].backgroundColor = Theme_ViewBackgroundColor;
    [[_tableViewInfo getTableView] reloadData];
}

#pragma mark - cell点击事件
- (void)didSelectCell:(CWTableViewCellInfo *)cellInfo indexPath:(NSIndexPath *)indexPath {
    
    JCNavigationController *nav = [self mainNav];
    if (!nav) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString  *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:@"我的任务"]) {
        TaskListContainerViewController *taskVC = [[TaskListContainerViewController alloc]init];
        taskVC._oc_scrollToIndex = 1;
        [nav.topViewController.navigationController pushViewController:taskVC animated:YES];
    }else if ([title isEqualToString:@"我的消息"]){
        JCConversationListViewController *conversationListVC = [[JCConversationListViewController alloc]init];
        [nav.topViewController.navigationController pushViewController:conversationListVC animated:YES];
    }else if ([title isEqualToString:@"我的钱包"]){
        //
        MyWalletViewController  *walletVC = [[MyWalletViewController alloc]init];
        [nav.topViewController.navigationController pushViewController:walletVC animated:YES];
    }else if ([title isEqualToString:@"退出登录"]){
        [[SCAppManager shareInstance]selectLogout];
//        [NotificationHandler handlerNotificationWithCustom:@{@"msg_body":@{@"action_type":@"open_page",@"action_body":@{@"page_name":@"setting_page"}},@"action_type":@"open_page"}];
    }else{
                                                                 
    }
//    switch (indexPath.row) {
//        case 0:
//            // 我的钱包
//
//            break;
//        case 1:
//            // 我的任务
//        {
//
//
//
//        }
//
//
//            break;
//        case 2:
//            //我的消息
//        {
//
//        }
//
//            break;
//        case 3:
//            // 我的收藏
//        {
//            MapFootprintViewController  *footprintVC = [[MapFootprintViewController alloc]initWithType:1];
//            [nav.topViewController.navigationController pushViewController:footprintVC animated:YES];
//        }
//            break;
//        case 4:
//            //实名认证
//        {
//            RealNameVeifiedViewController  *realNameVC = [[RealNameVeifiedViewController alloc]init];
//            [nav.topViewController.navigationController pushViewController:realNameVC animated:YES];
//        }
//
//
//            break;
//        case 5:
//        {
//            EditPersonalInfoViewController *editVC = [[EditPersonalInfoViewController alloc]init];
//            [nav.topViewController.navigationController pushViewController:editVC animated:YES];
//        }
//        default:
//            break;
//    }
    
}


#pragma mark - Getter
- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",
                        @"personal_myservice_icons",
                        @"personal_news_icons",
                        @"personal_order_icons",
                        @"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        if ([SCCacheTool shareInstance].status.integerValue == 0) {
            _titleArray = @[
                            @"我的消息",
                            @"退出登录"];
        }else{
            _titleArray = @[@"我的钱包",
                            @"我的任务",
                            @"我的消息",
                            @"退出登录"];
        }
     
    }
    return _titleArray;
}

#pragma mark -- DUX_UploadUserIconDelegate

-(void)uploadImageToServerWithImage:(UIImage *)image Tag:(NSInteger)tag{
    
     [[CWMaskView shareInstance]singleTap];
    
    if (!image) {
        return;
    }
    image = [image mc_resetToSize:CGSizeMake(64, 64)];
    image = [image cutCircleImage];
    weakify(self);
    [SCAliyunUploadMananger uploadImage:image withCompressionQuality:0.5 withCallBack:^(NSString *url) {
        if (!NULLString(url)) {
            [EditInfoService sc_editPersonalInfo:@{@"headImg":url} callBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [weak_self setIconImage];
                }
            }];
        }
    } withErrorCallBack:^(NSError *error) {
        [HHTool showError:error.localizedDescription];
    }];
    
}


@end
