//
//  SCContactFriendCell.h
//  ShanChain
//
//  Created by krew on 2017/6/8.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYContactsModel.h"

#import "SYFocusModel.h"

@interface SCContactFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *concernBtn;

@property (weak, nonatomic) IBOutlet UILabel *concernLabel;

@property(nonatomic,strong)NSDictionary *dic;

@property(nonatomic,strong)SYContactsModel *model;

//index 1:代表已经是善圆使用者，0 代表不是善圆使用者
@property (nonatomic, assign) int  index;


@property(nonatomic,strong)SYFocusModel *funsModel;



@end
