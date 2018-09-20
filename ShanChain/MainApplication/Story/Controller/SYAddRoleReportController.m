//
//  SYAddRoleReportController.m
//  ShanChain
//
//  Created by krew on 2017/8/29.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYAddRoleReportController.h"

@interface SYAddRoleReportController ()

@property(nonatomic,strong)UIImageView  *imgView;

@property(nonatomic,strong)UILabel      *nameLabel;

@end

@implementation SYAddRoleReportController

#pragma mark -懒加载
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = CGRectMake(118.0/375.0*SCREEN_WIDTH, 100.0/667*SCREEN_HEIGHT, 140.0/375*SCREEN_WIDTH, 140.0/375*SCREEN_WIDTH);
        _imgView.image = [UIImage imageNamed:@"abs_timeandspace_icon_time_default"];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 70.0/375*SCREEN_WIDTH;
    }
    return _imgView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(KSCMargin/375*SCREEN_WIDTH, CGRectGetMaxY(self.imgView.frame) + 35, SCREEN_WIDTH - KSCMargin * 2, 25);
        _nameLabel.text = @"我们将会在24小时内处理你的申诉";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _nameLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加新角色";
    
    self.view.backgroundColor = RGB(238, 238, 238);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:RGB(102, 102, 102)];
    
    [self setupViews];
    
}

- (void)setupViews{
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.nameLabel];
}

- (void)sureAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
