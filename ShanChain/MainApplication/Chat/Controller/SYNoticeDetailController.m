//
//  SYNoticeDetailController.m
//  ShanChain
//
//  Created by krew on 2017/9/15.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYNoticeDetailController.h"

@interface SYNoticeDetailController ()

@property(nonatomic,strong)UILabel      *titleLabel;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UIImageView  *imgView;

@end

@implementation SYNoticeDetailController
#pragma mark -懒加载
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"新版本上线，请仔细阅读一下说明";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = RGB(255, 237, 219);
        _titleLabel.textColor = RGB(255, 130, 0);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 36);
    }
    return _titleLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
//        _nameLabel.frame = CGRectMake(KSCMargin, CGRectGetMaxY(self.titleLabel.frame) + 10, SCREEN_WIDTH - 2 * KSCMargin, 80);
        _nameLabel.text = @"【新版本提醒】请仔细阅读穿越守则中最新说明，特别是：1.严禁崩皮，不要发布与人物不相符的言论，违者重罚。2.不许涉三，留联系方式请小窗私聊。谢谢配合！";
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.font = [UIFont systemFontOfSize:12];
//        _nameLabel.backgroundColor = [UIColor redColor];
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH  -KSCMargin * 2, MAXFLOAT);
        CGSize textSize = [_nameLabel.text sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
        _nameLabel.frame = (CGRect){{KSCMargin , CGRectGetMaxY(self.titleLabel.frame) + 10} , textSize };
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCMargin, CGRectGetMaxY(self.nameLabel.frame) + 10, SCREEN_WIDTH - 2 * KSCMargin, 200)];
        _imgView.image = [UIImage imageNamed:@"abs_addanewrole_def_photo_default"];
    }
    return _imgView;
}

#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"三体公告";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    
}

#pragma mark -构造方法
- (void)setupViews{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.imgView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
