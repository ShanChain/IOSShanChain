//
//  SYNoticeCell.m
//  ShanChain
//
//  Created by krew on 2017/10/17.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYNoticeCell.h"

@implementation SYNoticeCell

- (void)setModel:(SYNoticeModel *)model{
    _model = model;
    
    self.nameLabel.text = model.title;
    self.contentLabel.text = model.notice;
    self.timeLabel.text = [Util dynamicDisplayTime:[NSString stringWithFormat:@"%ld", model.createTime]];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
