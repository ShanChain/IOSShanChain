//
//  SYScreenInsideCell.m
//  ShanChain
//
//  Created by krew on 2017/9/22.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYScreenInsideCell.h"

@implementation SYScreenInsideCell

- (IBAction)quitBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(setScreenInsideQuitBtnClicked:)]) {
        [_delegate setScreenInsideQuitBtnClicked:self.indexPath];
    }
}


- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
    self.iconImgView.image = [UIImage imageNamed:dic[@"icon"]];
    self.nameLabel.text = dic[@"name"];
    self.contentLabel.text = dic[@"content"];
    self.authorLabel.text = dic[@"author"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 25.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
