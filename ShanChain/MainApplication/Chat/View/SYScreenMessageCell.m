//
//  SYScreenMessageCell.m
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScreenMessageCell.h"

@implementation SYScreenMessageCell

- (void)setModel:(SYMyGroupModel *)model{
    _model = model;
    
    NSDictionary *groupOwner = model.groupOwner;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:groupOwner[@"iconUrl"]] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    self.nameLabel.text = model.groupName;
    self.contentLabel.text = model.groupDesc;
    self.timeLabel.text = [Util dynamicDisplayTime:[NSString stringWithFormat:@"%ld", model.createTime]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
