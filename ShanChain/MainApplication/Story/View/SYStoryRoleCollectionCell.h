//
//  SYStoryRoleCollectionCell.h
//  ShanChain
//
//  Created by krew on 2017/8/28.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYCharacterModel;

@interface SYStoryRoleCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property(nonatomic,strong)SYCharacterModel *model;

@end
