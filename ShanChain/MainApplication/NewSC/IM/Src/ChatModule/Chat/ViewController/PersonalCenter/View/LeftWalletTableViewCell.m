//
//  LeftWalletTableViewCell.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/5.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "LeftWalletTableViewCell.h"

@implementation LeftWalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

#pragma mark - setter
- (void)setCellInfo:(CWTableViewCellInfo *)cellInfo {
    
    _cellInfo = cellInfo;
    self.accessoryType = cellInfo.accessoryType;
    self.selectionStyle = cellInfo.selectionStyle;
    self.backgroundColor = cellInfo.backGroudColor;
    self.nameLb.text = [cellInfo getCellInfoValueForKey:@"title"];
//    NSString *imageName = [cellInfo getCellInfoValueForKey:@"imageName"];
//    if (imageName) {
//        self.imageView.image = [UIImage imageNamed:imageName];
//    }
    
}
@end
