//
//  SCMessageCell.m
//  ShanChain
//
//  Created by krew on 2017/6/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCMessageCell.h"

@implementation SCMessageCell

- (void)setModel:(SYBigDramaModel *)model{
    _model = model;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    
    self.nameLabel.text = model.title;
    
    self.contentLabel.text = model.intro;
    
    self.timeLabel.text = [Util dynamicDisplayTime:[NSString stringWithFormat:@"%ld", model.createTime]];
    
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
