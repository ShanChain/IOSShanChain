//
//  SYNoticeCell.h
//  ShanChain
//
//  Created by krew on 2017/10/17.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNoticeModel.h"

@interface SYNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic,strong)SYNoticeModel *model;

@end
