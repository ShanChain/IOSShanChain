//
//  SCTopCell.m
//  ShanChain
//
//  Created by krew on 2017/6/1.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCTopCell.h"

@implementation SCTopCell

- (void)setModel:(SYComposeTrendModel *)model{
    _model = model;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.background] placeholderImage:[UIImage imageNamed:@"abs_topic_icon_notice_default"]];
    self.nameLabel.text = model.title;
    self.contentLabel.text = model.isNotExist ? @"#创建新话题#" : @"话题";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 25.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
