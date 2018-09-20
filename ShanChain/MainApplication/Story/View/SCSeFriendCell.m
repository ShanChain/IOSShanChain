//
//  SCSeFriendCell.m
//  ShanChain
//
//  Created by krew on 2017/5/31.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCSeFriendCell.h"

@interface SCSeFriendCell()

@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIImageView *iconImgView;
@property(nonatomic,strong)UILabel  *nameLabel;
@property(nonatomic,strong)UIView   *lineView;

@end

@implementation SCSeFriendCell
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_btn_determine_default"] forState:UIControlStateNormal];
        _selectBtn.userInteractionEnabled = NO;
    }
    return _selectBtn;
}

- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.layer.cornerRadius = 20.0f;
    }
    return _iconImgView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(232, 232, 232);
    }
    return _lineView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        self.selectionStyle     = UITableViewCellSelectionStyleGray;
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.lineView];
        [self layoutPageSubviews];
    }
    return self;
}

-(void)layoutPageSubviews{
    self.selectBtn.frame = CGRectMake(15, 14, 22, 22);
    self.iconImgView.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame)+13, 5, [SCSeFriendCell cellHeight]-10, [SCSeFriendCell cellHeight]-10);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImgView.frame)+20, 15, SCREEN_WIDTH-CGRectGetMaxX(self.iconImgView.frame)- 20 - 15, 20);
    self.lineView.frame = CGRectMake(0, [SCSeFriendCell cellHeight]-1, SCREEN_WIDTH, 1);
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)setFried:(SYFriend *)fried{
    _fried = fried;
    NSString *image = fried.headImg;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];

    self.nameLabel.text = fried.name;
    if (fried.isSelected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"icon_btn_determine_selectsd"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"icon_btn_determine_default"] forState:UIControlStateNormal];
    }
    
}

- (void)setModel:(SYContactModel *)model{
    _model = model;
    NSString *image = model.headImg;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    
    self.nameLabel.text = model.name;
    
    if (model.isSelected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"icon_btn_determine_selectsd"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"icon_btn_determine_default"] forState:UIControlStateNormal];
    }
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
