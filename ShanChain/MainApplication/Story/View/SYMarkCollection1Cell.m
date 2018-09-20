//
//  SYMarkCollection1Cell.m
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYMarkCollection1Cell.h"

@implementation SYMarkCollection1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemTitleView.layer.masksToBounds = YES;
    self.itemTitleView.layer.cornerRadius = 8.0f;
    self.itemTitleView.layer.borderColor = [RGB(179, 179, 179)CGColor];
    self.itemTitleView.layer.borderWidth = 1.0f;
}

- (void)updateSelectState:(BOOL)selected {
    if (selected) {
        self.itemTitleLabel.textColor = RGB(255, 255, 255);
        self.itemTitleView.layer.backgroundColor = RGB(59, 187, 200).CGColor;
        self.itemTitleView.layer.borderColor = RGB(59, 187, 200).CGColor;
    } else {
        self.itemTitleLabel.textColor = RGB(102, 102, 102);
        self.itemTitleView.layer.borderColor = RGB(180, 180, 180).CGColor;
        self.itemTitleView.layer.backgroundColor = RGB(255, 255, 255).CGColor;
    }
}

@end
