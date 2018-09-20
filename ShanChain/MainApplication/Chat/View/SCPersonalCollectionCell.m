//
//  SCPersonalCollectionCell.m
//  ShanChain
//
//  Created by krew on 2017/6/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCPersonalCollectionCell.h"

@implementation SCPersonalCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 25.0f;
    
}

@end
