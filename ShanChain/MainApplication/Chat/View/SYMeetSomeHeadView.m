//
//  SYMeetSomeHeadView.m
//  ShanChain
//
//  Created by krew on 2017/9/18.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYMeetSomeHeadView.h"

@interface SYMeetSomeHeadView()

@property(nonatomic,strong)UIImageView  *headImgView;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UIButton     *roleBtn;
@property(nonatomic,strong)UIButton     *concernBtn;
@property(nonatomic,strong)UILabel      *contentLabel;
@property(nonatomic,strong)UILabel      *sourceLabel;
@property(nonatomic,strong)UIView       *lineView;

@end

@implementation SYMeetSomeHeadView
#pragma mark -懒加载
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 50)/2, 30, 50, 50)];
        _headImgView.image = [UIImage imageNamed:@"abs_addanewrole_def_photo_default"];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 25.0f;
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel ) {
        _nameLabel = [UILabel new];
        _nameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.headImgView.frame) + 10, SCREEN_WIDTH, 20);
        _nameLabel.text = @"王伟";
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UIButton *)roleBtn{
    if (!_roleBtn) {
        _roleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _roleBtn.frame = CGRectMake(90.0/375*SCREEN_WIDTH, 140.0/667*SCREEN_HEIGHT, 90.0, 34);
        [_roleBtn setTitle:@"以角色聊天" forState:UIControlStateNormal];
        [_roleBtn setTitleColor:RGB(59, 186, 200) forState:UIControlStateNormal];
        [_roleBtn addTarget:self action:@selector(roleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _roleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _roleBtn.layer.masksToBounds = YES;
        _roleBtn.layer.cornerRadius = 8.0f;
        _roleBtn.layer.borderColor = [RGB(59, 186, 200)CGColor];
        _roleBtn.layer.borderWidth = 1.0f;
    }
    return _roleBtn;
}

- (UIButton *)concernBtn{
    if (!_concernBtn) {
        _concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _concernBtn.frame = CGRectMake(200.0/375*SCREEN_WIDTH, 140.0/667*SCREEN_HEIGHT, 90, 34);
        [_concernBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_concernBtn setTitle:@"关注" forState:UIControlStateNormal];
        _concernBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _concernBtn.backgroundColor = RGB(59, 186, 200);
        _concernBtn.layer.masksToBounds = YES;
        _concernBtn.layer.cornerRadius = 8.0;
        _concernBtn.layer.borderWidth = 1.0f;
        _concernBtn.layer.borderColor = [RGB(59, 187, 202)CGColor];
    }
    return _concernBtn;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.frame = CGRectMake(KSCMargin, 200.0/667*SCREEN_HEIGHT, 100, 20);
        _contentLabel.text = @"TA添加了故事";
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = RGB(102, 102, 102);
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [UILabel new];
        _sourceLabel.frame = CGRectMake(SCREEN_WIDTH / 2, 200.0/667*SCREEN_HEIGHT, SCREEN_WIDTH / 2 - KSCMargin, 20);
        _sourceLabel.text = @"来自 无故事王国的王子";
        _sourceLabel.textAlignment = NSTextAlignmentRight;
        _sourceLabel.textColor = RGB(59, 187, 200);
        _sourceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sourceLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 230.0/667*SCREEN_HEIGHT, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = RGB(238, 238, 238);
    }
    return _lineView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)roleBtnAction{
    SCLog(@"点击了控件");
}

- (void)setupView{
    [self addSubview:self.headImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.roleBtn];
    [self addSubview:self.concernBtn];
    [self addSubview:self.contentLabel];
    [self addSubview:self.sourceLabel];
    [self addSubview:self.lineView];
}

@end
