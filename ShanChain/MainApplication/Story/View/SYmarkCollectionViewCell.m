//
//  SYmarkCollectionViewCell.m
//  ShanChain
//
//  Created by krew on 2017/8/25.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYmarkCollectionViewCell.h"
#import "SYMarkModel.h"

@interface SYmarkCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SYmarkCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 10.0f;
    
}

-(void)setMarkModel:(SYMarkModel *)markModel{
    _markModel = markModel;
        
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:markModel.background] placeholderImage:[UIImage imageNamed:@"abs_addanewrole_def_photo_default"]];
    self.nameLabel.text = markModel.name;
    self.contentLabel.text = markModel.intro;
    
}


@end
