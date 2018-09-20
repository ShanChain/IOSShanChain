//
//  SYMarkCollection2Cell.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYMarkCollection2Cell.h"
#import "SYMarkModel.h"

@interface SYMarkCollection2Cell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SYMarkCollection2Cell

- (void)setModel:(SYMarkModel *)model{
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.background] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    self.titleLabel.text = model.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
}

@end
