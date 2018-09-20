//
//  SCContactFriendCell.m
//  ShanChain
//
//  Created by krew on 2017/6/8.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCContactFriendCell.h"

@implementation SCContactFriendCell

- (void)setFunsModel:(SYFocusModel *)funsModel{
    _funsModel = funsModel;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:funsModel.headImg] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    NSString *name = [[funsModel.name stringByAppendingString:@"."] stringByAppendingString:[NSString stringWithFormat:@"%ld", funsModel.modelNo]];
    self.nameLabel.text = name;
    self.detailNameLabel.text = funsModel.intro;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 25.0f;
    
    self.concernBtn.hidden = YES;
    self.concernLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
