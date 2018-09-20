//
//  SCMessageSettingCell.h
//  ShanChain
//
//  Created by krew on 2017/6/29.
//  Copyright © 2017年 krew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMessageSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property(nonatomic,strong)NSDictionary *dic;

@end
