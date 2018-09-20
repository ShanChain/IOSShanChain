//
//  SCTopCell.h
//  ShanChain
//
//  Created by krew on 2017/6/1.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYComposeTrendModel.h"

@interface SCTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,strong)SYComposeTrendModel *model;

@end
