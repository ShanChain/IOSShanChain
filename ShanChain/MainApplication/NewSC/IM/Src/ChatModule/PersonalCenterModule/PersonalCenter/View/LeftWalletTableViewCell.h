//
//  LeftWalletTableViewCell.h
//  ShanChain
//
//  Created by 千千世界 on 2018/11/5.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTableViewCellInfo.h"

@interface LeftWalletTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *seatMoneyLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (nonatomic, weak) CWTableViewCellInfo *cellInfo;

@end
