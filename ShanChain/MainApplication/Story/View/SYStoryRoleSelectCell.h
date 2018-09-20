//
//  SYStoryRoleSelectCell.h
//  ShanChain
//
//  Created by krew on 2017/9/19.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYCharacterModel;

@interface SYStoryRoleSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,strong)SYCharacterModel *model;

@end
