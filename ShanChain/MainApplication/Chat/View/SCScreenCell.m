//
//  SCScreenCell.m
//  ShanChain
//
//  Created by krew on 2017/11/1.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SCScreenCell.h"

CGFloat const EaseMessageScreenCellPadding = 15;

@interface SCScreenCell()

@property (strong, nonatomic) UIView   *bgView;

@property (strong, nonatomic) UILabel   *titleLabel;

@property (strong, nonatomic) UILabel    *contentLabel;

@end

@implementation SCScreenCell

+ (void)initialize {
    // UIAppearance Proxy Defaults
    SCScreenCell *cell = [self appearance];
    cell.titleLabelColor = RGB(255, 255, 255);
    cell.titleLabelFont = [UIFont systemFontOfSize:14];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _setupSubview];
    }
    
    return self;
}

#pragma mark - setup subviews

- (void)_setupSubview
{
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = RGB(187, 187, 187);
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0f;
    [self.contentView addSubview:_bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(EaseMessageScreenCellPadding);
        make.right.bottom.mas_equalTo(-EaseMessageScreenCellPadding);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel makeTextStyleWithTitle:@"情境" withColor:RGB(255, 255, 255) withFont:[UIFont systemFontOfSize:14] withAlignment:NSTextAlignmentCenter];
    [_bgView addSubview:_titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(16);
    }];
    
    _contentLabel = [[UILabel alloc]init];
    [_contentLabel makeTextStyleWithTitle:@"来制造个情景" withColor:RGB(255, 255, 255) withFont:[UIFont systemFontOfSize:12] withAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EaseMessageScreenCellPadding);
        make.right.mas_equalTo(-EaseMessageScreenCellPadding);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.mas_equalTo(-5);
    }];
}
#pragma mark - setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor
{
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = RGB(255, 255, 255);
}
+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model {
    NSString *content = model.text;
    CGSize size = [content sizeWithDictionary:@{
                                                NSFontAttributeName:[UIFont systemFontOfSize:12]
                                                } maxSize:CGSizeMake(SCREEN_WIDTH - 80, CGFLOAT_MAX)];
    return 70 + size.height;
}
#pragma mark - public

+ (NSString *)cellIdentifier{
    return @"SCScreenCell";
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
