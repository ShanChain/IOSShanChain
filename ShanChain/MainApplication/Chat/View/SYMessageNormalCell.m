//
//  SYMessageNormalCell.m
//  ShanChain
//
//  Created by 善融区块链 on 2017/12/14.
//  Copyright © 2017年 ShanChain. All rights reserved.
//

#import "SYMessageNormalCell.h"

@interface SYMessageNormalCell()

@property (strong, nonatomic) UILabel *isOwnerLabel;

@property (strong, nonatomic) UIImageView *headView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIView *contentContainerView;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation SYMessageNormalCell

- (UILabel *)isOwnerLabel {
    if (!_isOwnerLabel) {
        _isOwnerLabel = [[UILabel alloc] init];
        [_isOwnerLabel makeTextStyleWithTitle:@"本人说" withColor:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:10] withAlignment:NSTextAlignmentCenter];
        _isOwnerLabel.backgroundColor = RGB(187, 187, 187);
        _isOwnerLabel.layer.masksToBounds = YES;
        _isOwnerLabel.layer.cornerRadius = 6.0f;
    }
    
    return _isOwnerLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel makeTextStyleWithTitle:@"" withColor:RGB_HEX(0xBBBBBB) withFont:[UIFont systemFontOfSize:14] withAlignment:NSTextAlignmentRight];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel makeTextStyleWithTitle:@"" withColor:RGB_HEX(0xFFFFFF) withFont:[UIFont systemFontOfSize:14] withAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _contentLabel;
}

- (UIView *)contentContainerView {
    if (!_contentContainerView) {
        _contentContainerView = [[UIView alloc] init];
    }
    
    return _contentContainerView;
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
        [_headView makeLayerWithRadius:25 withBorderColor:[UIColor clearColor] withBorderWidth:0];
        _headView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeadImageTap:)];
        tap.numberOfTapsRequired = 1;
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}

- (CAGradientLayer *)gradientLayer {
    if(!_gradientLayer) {
        _gradientLayer = [CAGradientLayer new];
    }
    
    return _gradientLayer;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(id<IMessageModel>)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _model = model;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.backgroundColor = RGB_HEX(0xEEEEEE);
    [self.contentView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.isSender) {
            make.right.mas_equalTo(@-15);
        } else {
            make.left.mas_equalTo(@15);
        }
        make.width.height.mas_equalTo(@50);
        make.top.mas_equalTo(@10);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.isSender) {
            make.right.equalTo(self.headView.mas_left).with.offset(-15);
        } else {
            make.left.equalTo(self.headView.mas_right).with.offset(15);
        }
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(self.headView);
    }];
    [self.contentView addSubview:self.contentContainerView];
    if (_model.isSender) {
        self.contentContainerView.frame = CGRectMake(SCREEN_WIDTH - 60 - 80, 35, 60, 30);
    } else {
        self.contentContainerView.frame = CGRectMake(80, 35, 60, 30);
    }
    [self.contentContainerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.contentView addSubview:self.isOwnerLabel];
    [self.isOwnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.isSender) {
            make.right.equalTo(self.contentContainerView.mas_left).with.offset(-15);
        } else {
            make.left.equalTo(self.contentContainerView.mas_right).with.offset(15);
        }
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.contentContainerView);
    }];
}

- (void)setModel:(id<IMessageModel>)model {
    _model = model;

    self.nameLabel.textAlignment = model.isSender ? NSTextAlignmentRight : NSTextAlignmentLeft;
    
    self.nameLabel.text = model.nickname;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    
    self.contentLabel.text = model.text;
    
    CGFloat minY = CGRectGetMinY(self.contentContainerView.frame);
    NSString *content = model.text;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 160, CGFLOAT_MAX)];
    size.height = (size.height > 25 ? size.height + 20 : 25);
    size.width = size.width > 25 ? size.width + 15 : 35;
    if (model.isSender) {
        self.contentContainerView.frame = CGRectMake(SCREEN_WIDTH - 80 - size.width, minY, size.width, size.height);
    } else {
        self.contentContainerView.frame = CGRectMake(80, minY, size.width, size.height);
    }
    
    NSDictionary *extension = model.message.ext;
    self.isOwnerLabel.hidden = !(extension[HX_EXT_MSG_ATTR] == @0);
    
    if (model.isSender) {
        self.contentContainerView.backgroundColor = RGB_HEX(0xBBBBBB);
    } else {
        self.contentContainerView.backgroundColor = (extension[HX_EXT_MSG_ATTR] == @1 ? RGB_HEX(0xFFFFFF) : RGB_HEX(0xBBBBBB));
        self.contentLabel.textColor = (extension[HX_EXT_MSG_ATTR] == @1 ? RGB_HEX(0x666666) : [UIColor whiteColor]);
    }
    
    UIBezierPath *maskPath = nil;
    if (self.model.isSender) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentContainerView.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    } else {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentContainerView.layer.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = _contentContainerView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    _contentContainerView.layer.mask = maskLayer;
    
    if (self.model.isSender && self.model.message.ext[HX_EXT_MSG_ATTR] == @1) {
        self.gradientLayer.frame = _contentContainerView.bounds;
        self.gradientLayer.startPoint = CGPointMake(0.5, 0);
        self.gradientLayer.endPoint = CGPointMake(0.5, 1.0f);
        self.gradientLayer.colors = @[(__bridge id)RGB_HEX(0x5CEECA).CGColor,(__bridge id)RGB_HEX(0x3BBAC8).CGColor];
        [_contentContainerView.layer insertSublayer:self.gradientLayer atIndex:0];
    } else {
        [self.gradientLayer removeFromSuperlayer];
    }
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model {
    NSString *content = model.text;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, CGFLOAT_MAX)];

    CGFloat height = (size.height > 25 ? size.height + 20 : 25);
    // 头像加上下的间距
    CGFloat minHeight = 70;
    
    return height + 50 > minHeight ? height + 50 : minHeight;

}

- (void)handleHeadImageTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([_delegate respondsToSelector:@selector(messageNormalCellHeadTapWith:withModel:)]){
        [_delegate messageNormalCellHeadTapWith:_indexPath withModel:_model];
    }
}

@end
