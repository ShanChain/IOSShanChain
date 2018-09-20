//
//  SYScreenCell.m
//  ShanChain
//
//  Created by krew on 2017/9/14.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScreenCell.h"

@implementation SYScreenCell

- (void) setDic:(NSDictionary *)dic{
    _dic = dic;
    self.nameLabel.text = dic[@"name"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
