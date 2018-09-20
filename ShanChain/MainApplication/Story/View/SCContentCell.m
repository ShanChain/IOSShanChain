//
//  SCContentCell.m
//  ShanChain
//
//  Created by krew on 2017/6/1.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCContentCell.h"

@interface SCContentCell()

@property(nonatomic,strong)UIImageView  *iconImgView;
@property(nonatomic,strong)UILabel      *nameLabel;
@property(nonatomic,strong)UILabel      *cityLabel;
@property(nonatomic,strong)UILabel      *timeLabel;
@property(nonatomic,strong)UIButton     *likeBtn;
@property(nonatomic,strong)UILabel      *likeValue;
@property(nonatomic,strong)UILabel      *contentLabel;
@property(nonatomic,strong)UIView       *lineView;

@end

@implementation SCContentCell

-(UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.layer.cornerRadius = 15.0f;
    }
    return _iconImgView;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = RGB(58, 185, 199);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}

-(UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.textAlignment = NSTextAlignmentLeft;
        _cityLabel.textColor = RGB(179, 179, 179);
        _cityLabel.font = [UIFont systemFontOfSize:10];
    }
    return _cityLabel;
}

-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = RGB(179, 179, 179);
        _timeLabel.font = [UIFont systemFontOfSize:10];
    }
    return _timeLabel;
}

-(UILabel *)likeValue {
    if (!_likeValue) {
        _likeValue = [[UILabel alloc]init];
        _likeValue.font = [UIFont systemFontOfSize:10];
        _likeValue.textAlignment = NSTextAlignmentRight;
        _likeValue.textColor = RGB(179, 179, 179);
    }
    return _likeValue;
}

-(UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImageNormal:@"abs_home_btn_thumbsup_default" withImageHighlighted:@"abs_home_btn_thumbsup_selscted"];
        [_likeBtn addTarget:self action:@selector(likeActionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

-(UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = RGB(83, 83, 83);
        _contentLabel.font = [UIFont systemFontOfSize:12];
    }
    return _contentLabel;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(246, 246, 246);
    }
    return _lineView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        self.selectionStyle     = UITableViewCellSelectionStyleGray;
        
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.cityLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.likeValue];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
        [self layoutPageSubviews];
    }
    return self;
}

- (void)layoutPageSubviews {
    self.iconImgView.frame = CGRectMake(15, 10, 30, 30);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImgView.frame)+10, 15, 50, 17);
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH-15-15, 12, 15, 15);
    self.likeValue.frame = CGRectMake(CGRectGetMinX(self.likeBtn.frame)-30, 12, 20, 14);
    self.timeLabel.frame = CGRectMake(CGRectGetMinX(self.likeValue.frame)-80,12, 60, 14);
    CGFloat contentX = 15;
    CGFloat contentY = CGRectGetMaxY(self.iconImgView.frame) + DSStatusCellInset;
    CGFloat contentW = App_Frame_Width - 2 *contentX;
    CGSize maxSize = CGSizeMake(contentW, MAXFLOAT);
        
    CGSize textSize = [@"重要的不是这件事的真相，而是你们的态度重要的不是这件事的真相，而是你们的态度" sizeWithFont:DSStatusOriginalNameFont maxSize:maxSize];
    self.contentLabel.frame = (CGRect){{contentX , contentY} , textSize };
    
    self.lineView.frame = CGRectMake(0, [SCContentCell cellHeight]-2, SCREEN_WIDTH, 2);
}

- (void)likeActionAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(contentCellTapButtonSupportWithIndexPath:withSupported:)]){
        [_delegate contentCellTapButtonSupportWithIndexPath:self.indexpath withSupported:!sender.selected];
    }
}

+ (CGFloat)cellHeight {
    return 105;
}

- (void)setComment:(SYComment *)comment {
    _comment = comment;
    NSDictionary *info = comment.info;
    self.likeBtn.selected = comment.mySupport.boolValue;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:info[@"headImg"]] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    self.timeLabel.text = [Util dynamicDisplayTime:comment.createTime];
    self.likeValue.text = [NSString stringWithFormat:@"%ld",comment.supportCount];
    self.nameLabel.text = info[@"name"];
    self.contentLabel.text = comment.content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
