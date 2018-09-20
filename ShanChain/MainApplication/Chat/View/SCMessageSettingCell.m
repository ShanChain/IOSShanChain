//
//  SCMessageSettingCell.m
//  ShanChain
//
//  Created by krew on 2017/6/29.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SCMessageSettingCell.h"

@implementation SCMessageSettingCell

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.nameLabel.text = dic[@"name"];
    if ([dic[@"isOn"]isEqualToString:@"是"]) {
        self.switchBtn.on = YES;
    }else{
        self.switchBtn.on = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
