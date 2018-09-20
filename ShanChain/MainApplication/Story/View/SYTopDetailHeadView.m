//
//  SYTopDetailHeadView.m
//  ShanChain
//
//  Created by krew on 2017/9/4.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYTopDetailHeadView.h"

@interface SYTopDetailHeadView()

@property(nonatomic,strong)UIImageView  *imgView;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UILabel      *talkLabel;
@property(nonatomic,strong)UIView       *contentView;
@property(nonatomic,strong)UILabel      *readLabel;
@property(nonatomic,strong)UILabel      *contentLabel;

@property(nonatomic,strong)UIView       *lineView;

@end

@implementation SYTopDetailHeadView
#pragma mark -懒加载
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
        _imgView.backgroundColor = RGB_HEX(0xBBBBBB);
    }
    return _imgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.frame = CGRectMake(KSCMargin, 10, 150, 17);
        _nameLabel.textColor = RGB(255, 255, 255);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}

- (UILabel *)talkLabel{
    if (!_talkLabel) {
        _talkLabel = [UILabel new];
        _talkLabel.textAlignment = NSTextAlignmentLeft;
        _talkLabel.font = [UIFont systemFontOfSize:12];
        _talkLabel.textColor = RGB(255, 255, 255);
        _talkLabel.frame = CGRectMake(250.0/375*SCREEN_WIDTH, 10, 50, 17);
    }
    return _talkLabel;
}

- (UILabel *)readLabel{
    if (!_readLabel) {
        _readLabel = [UILabel new];
        _readLabel.textAlignment = NSTextAlignmentRight;
        _readLabel.font = [UIFont systemFontOfSize:12];
        _readLabel.textColor = RGB(255, 255, 255);
        _readLabel.frame = CGRectMake(305.0/375*SCREEN_WIDTH, 10, 60, 17);
    }
    return _readLabel;
}

- (UILabel *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = RGBA(0, 0, 0, 0.4);
        _contentView.frame = CGRectMake(0, 170, SCREEN_WIDTH, 70);
    }
    return _contentView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = RGB(255, 255, 255);
        _contentLabel.frame = CGRectMake(KSCMargin, 8, SCREEN_WIDTH - 2 * KSCMargin, 50);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(246, 246, 246);
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame), SCREEN_WIDTH, 5);
    }
    return _lineView;
}

#pragma mark -系统方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - 构造方法
-(void)setupViews{
    
    [self addSubview:self.imgView];
    
    [self.imgView addSubview:self.nameLabel];
    [self.imgView addSubview:self.talkLabel];
    [self.imgView addSubview:self.readLabel];
    [self.imgView addSubview:self.contentView];
    
    [self addSubview:self.lineView];

    [self.contentView addSubview:self.contentLabel];
    
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"background"]]];
    self.nameLabel.text = [[@"#" stringByAppendingString:dic[@"title"]] stringByAppendingString:@"#"];
    self.talkLabel.text = [[dic[@"storyNum"] stringValue] stringByAppendingString:@"讨论"];
    self.readLabel.text = [[dic[@"readNum"] stringValue] stringByAppendingString:@"阅读"];
    self.contentLabel.text = dic[@"intro"];
}

@end
