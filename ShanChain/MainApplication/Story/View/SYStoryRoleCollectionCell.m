//
//  SYStoryRoleCollectionCell.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYStoryRoleCollectionCell.h"
#import "SYCharacterModel.h"

@interface SYStoryRoleCollectionCell()

@end

@implementation SYStoryRoleCollectionCell

- (void)setModel:(SYCharacterModel *)model{
    _model = model;
    
    self.nameLabel.text = model.name;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 25.0;
    
}

@end
