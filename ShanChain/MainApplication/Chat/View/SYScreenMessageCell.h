//
//  SYScreenMessageCell.h
//  ShanChain
//
//  Created by krew on 2017/10/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMyGroupModel.h"

@interface SYScreenMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,strong)SYMyGroupModel *model;


@end
