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

#define HeaderViewHeight 200

@interface LeftViewController ()<DUX_UploadUserIconDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy)   UIImageView   *icon;

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

- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, HeaderViewHeight)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
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
    [layerView _setCornerRadiusCircle];
    
    UIImageView  *img = [[UIImageView alloc]init];
    [img _sd_setImageWithURLString:[JMSGUser myInfo].avatar placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    _icon = img;
    [layerView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(layerView);
    }];
    [img _setCornerRadiusCircle];
    
    UILabel  *nikeNameLb = [[UILabel alloc]init];
    nikeNameLb.textColor = [UIColor whiteColor];
    nikeNameLb.font = Font(17);
    nikeNameLb.text = [SCCacheTool shareInstance].characterModel.characterInfo.name;
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
    signatureLb.text = [SCCacheTool shareInstance].characterModel.characterInfo.intro ? :@"暂无签名";
    [self.view addSubview:signatureLb];
    [signatureLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nikeNameLb.mas_bottom).offset(10);
        make.left.equalTo(layerView.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(self.view.height - 150);
        make.height.equalTo(@25);
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
    
    [self didSelectCell:nil indexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
}

- (void)changesIcon{
    [UPLOAD_IMAGE showActionSheetInFatherViewController:self imageTag:100 delegate:self];
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
    
    JCNavigationController *nav;
    if ([[HHTool mainWindow].rootViewController isKindOfClass:[JCMainTabBarController  class]]) {
        JCMainTabBarController  *tab = (JCMainTabBarController*)[HHTool mainWindow].rootViewController;
         JCNavigationController *navController = tab.selectedViewController;
         nav = navController;
    }else{
         nav = (JCNavigationController*)[HHTool mainWindow].rootViewController;
    }

    
    if (!nav) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (indexPath.row) {
        case 0:
            // 我的钱包
            
            break;
        case 1:
            // 我的任务
        {
            
            TaskListContainerViewController *taskVC = [[TaskListContainerViewController alloc]init];
            [nav.topViewController.navigationController pushViewController:taskVC animated:YES];
            
        }
            
            
            break;
        case 2:
            //我的消息
        {
            JCConversationListViewController *conversationListVC = [[JCConversationListViewController alloc]init];
            [nav.topViewController.navigationController pushViewController:conversationListVC animated:YES];
        }
            
            break;
        case 3:
            // 我的收藏
        {
            MapFootprintViewController  *footprintVC = [[MapFootprintViewController alloc]initWithType:1];
            [nav.topViewController.navigationController pushViewController:footprintVC animated:YES];
        }
            break;
        case 4:
            //实名认证
        {
            RealNameVeifiedViewController  *realNameVC = [[RealNameVeifiedViewController alloc]init];
            [nav.topViewController.navigationController pushViewController:realNameVC animated:YES];
        }
            
            
            break;
        case 5:
        {
            EditPersonalInfoViewController *editVC = [[EditPersonalInfoViewController alloc]init];
            [nav.topViewController.navigationController pushViewController:editVC animated:YES];
        }
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
                        @"设置"];
    }
    return _titleArray;
}

#pragma mark -- DUX_UploadUserIconDelegate

-(void)uploadImageToServerWithImage:(UIImage *)image Tag:(NSInteger)tag{
    NSData *imageData = UIImagePNGRepresentation(image);
    [JMSGUser updateMyAvatarWithData:imageData avatarFormat:@"png" completionHandler:^(id resultObject, NSError *error) {
        if(!error){
            NSLog(@"更换极光头像成功");
            _icon.image = image;
        }
    }];

    
//    [SCAliyunUploadMananger uploadImage:image withCompressionQuality:0.5 withCallBack:^(NSString *url) {
//        NSString *urlJson = @{@"headImg":url}.mj_JSONString;
//        NSDictionary  *params = @{@"characterId":[SCCacheTool shareInstance].getCurrentCharacterId,@"headImg":urlJson};
//        [[SCNetwork shareInstance]v1_postWithUrl:CHANGE_USER_CHARACTER params:params showLoading:NO callBlock:^(HHBaseModel *baseModel, NSError *error) {
//            if(error){
//
//            }
//
//
//        }];
//
//    } withErrorCallBack:^(NSError *error) {
//
//    }];
    
}


@end
