//
//  SYReportSuccessController.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYReportSuccessController.h"

@interface SYReportSuccessController ()

@property (nonatomic, strong) UIImageView  *imgView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *contentLabel;

@property (nonatomic, strong) UIView       *titleView;

@end

@implementation SYReportSuccessController

#pragma mark -懒加载
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = CGRectMake(118.0/375.0*SCREEN_WIDTH, 100.0/667*SCREEN_HEIGHT, 140.0/375*SCREEN_WIDTH, 140.0/375*SCREEN_WIDTH);
        _imgView.image = [UIImage imageNamed:@"sex_4.jpg"];
        [_imgView makeLayerWithRadius:70 withBorderColor:[UIColor clearColor] withBorderWidth:0];
    }
    return _imgView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel makeTextStyleWithTitle:@"举报已提交，我们将尽快处理" withColor:RGB(102, 102, 102) withFont:[UIFont systemFontOfSize:18] withAlignment:NSTextAlignmentCenter];
        _nameLabel.frame = CGRectMake(KSCMargin/375*SCREEN_WIDTH, CGRectGetMaxY(self.imgView.frame) + 35, SCREEN_WIDTH - KSCMargin * 2, 25);
    }
    return _nameLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [_nameLabel makeTextStyleWithTitle:@"感谢你的举报，我们将尽快《千千世界使用协议》进行审核（夜间时段稍有延迟）" withColor:RGB(102, 102, 102) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
//        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 2 * 60, MAXFLOAT);
//        CGSize textSize = [_contentLabel.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _contentLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 100);
        _contentLabel.center = self.view.center;
       
        
    }
    return _contentLabel;
}

-(UIView *)titleView{
    if (!_titleView ) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH,64);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, 25)];
        label.textColor = RGB(102, 102, 102);
        label.text = @"举报成功";
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        
        [_titleView addSubview:label];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(330.0/375*SCREEN_WIDTH, 34, 40, 20);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [sureBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_titleView addSubview:sureBtn];
        
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"举报成功";
    
    self.view.backgroundColor = RGB(238, 238, 238);
    [self.navigationItem setHidesBackButton:YES];
    [self addRightBarButtonItemWithTarget:self sel:@selector(sureBtnClick) title:@"确定" tintColor:UIColor.whiteColor];
    
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.titleView];
}

- (void)sureBtnClick{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
