//
//  SYStoryRoleSelectCell.m
//  ShanChain
//
//  Created by krew on 2017/9/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRoleSelectCell.h"
#import "SYCharacterModel.h"

@implementation SYStoryRoleSelectCell

- (void)setModel:(SYCharacterModel *)model{
    
    _model = model;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.intro;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 8.0f;
    self.contentLabel.height = 80;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
