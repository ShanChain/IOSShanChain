//
//  SCMessageCell.h
//  ShanChain
//
//  Created by krew on 2017/6/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYBigDramaModel.h"

@interface SCMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UIImageView *tipImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic,strong)SYBigDramaModel *model;

@property(nonatomic,strong)NSDictionary *dic;

@end
